import 'dart:io';
import 'dart:typed_data';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'database_helper.dart';
import 'env_config.dart';

class GoogleDriveService {
  static const List<String> _scopes = [drive.DriveApi.driveFileScope];

  static GoogleSignIn? _googleSignIn;
  static drive.DriveApi? _driveApi;
  static bool _isInitialized = false;

  // Initialize Google Sign-In
  static Future<void> initialize() async {
    if (_isInitialized) return;

    EnvConfig.printConfig();

    // Try without client ID first (more reliable for some configurations)
    _googleSignIn = GoogleSignIn(
      scopes: _scopes,
      // Comment out client ID temporarily to test
      // clientId: EnvConfig.hasGoogleCredentials
      //     ? EnvConfig.googleOAuthClientId
      //     : null,
    );

    _isInitialized = true;

    if (EnvConfig.debugMode) {
      print('GoogleDriveService initialized WITHOUT client ID (testing mode)');
    }
  }

  // Sign in using authHeaders approach (more reliable)
  static Future<bool> signInToGoogle() async {
    try {
      await initialize();

      if (EnvConfig.debugMode) {
        print('Starting Google Sign-In with authHeaders approach...');
      }

      // Try silent sign-in first
      GoogleSignInAccount? account = await _googleSignIn!.signInSilently();

      if (account == null) {
        if (EnvConfig.debugMode) {
          print('Silent sign-in failed, trying interactive sign-in...');
        }
        account = await _googleSignIn!.signIn();
      }

      if (account == null) {
        print('Google Sign-In cancelled by user');
        return false;
      }

      if (EnvConfig.debugMode) {
        print('Signed in as: ${account.email}');
        print('Getting auth headers...');
      }

      try {
        // Use authHeaders instead of access tokens (more reliable)
        final Map<String, String> authHeaders = await account.authHeaders;

        if (EnvConfig.debugMode) {
          print('Auth headers received: ${authHeaders.keys.toList()}');
          print('Auth headers count: ${authHeaders.length}');
        }

        if (authHeaders.isEmpty) {
          print('No auth headers received');
          return false;
        }

        // Create authenticated HTTP client using authHeaders
        final http.Client httpClient = _GoogleAuthClient(authHeaders);
        _driveApi = drive.DriveApi(httpClient);

        // Test the API connection
        if (EnvConfig.debugMode) {
          print('Testing Drive API connection...');
        }

        final about = await _driveApi!.about.get($fields: 'user');

        if (EnvConfig.debugMode) {
          print('✅ Drive API connection successful!');
          print('User: ${about.user?.displayName}');
          print('Email: ${about.user?.emailAddress}');
        }

        return true;
      } catch (e) {
        print('❌ Auth headers error: $e');
        print('This might be a scope or API permission issue');
        return false;
      }
    } catch (e) {
      print('❌ Error signing in to Google: $e');
      print('Error type: ${e.runtimeType}');

      if (e.toString().contains('DEVELOPER_ERROR')) {
        print('🔴 DEVELOPER_ERROR: Try without client ID first');
      } else if (e.toString().contains('NETWORK_ERROR')) {
        print('🔴 NETWORK_ERROR: Check internet connection');
      } else if (e.toString().contains('SIGN_IN_REQUIRED')) {
        print('🔴 User needs to sign in again');
      }

      return false;
    }
  }

  // Upload database to Google Drive (simplified version)
  static Future<bool> uploadDatabase() async {
    try {
      if (_driveApi == null) {
        bool signedIn = await signInToGoogle();
        if (!signedIn) return false;
      }

      // Get database file
      final Database db = await DatabaseHelper.database;
      final File dbFile = File(db.path);

      if (!await dbFile.exists()) {
        print('Database file not found');
        return false;
      }

      final Uint8List dbBytes = await dbFile.readAsBytes();
      final List<String> folderIds = await _getOrCreateBackupFolder();

      if (folderIds.isEmpty) return false;

      final drive.Media media = drive.Media(
        Stream.fromIterable([dbBytes]),
        dbBytes.length,
        contentType: 'application/x-sqlite3',
      );

      // Upload with timestamp for backup
      await _uploadFile(
        fileName: 'patients_backup_${DateTime.now().toIso8601String()}.db',
        media: media,
        folderIds: folderIds,
        description: 'Backup - ${DateTime.now().toIso8601String()}',
      );

      // Upload/update main file
      await _uploadOrUpdateFile(
        fileName: 'patients.db',
        media: media,
        folderIds: folderIds,
        description: 'Main database file - ${DateTime.now().toIso8601String()}',
      );

      print('✅ Database uploaded successfully!');
      return true;
    } catch (e) {
      print('❌ Error uploading database: $e');
      return false;
    }
  }

  // Helper method to upload a new file
  static Future<drive.File> _uploadFile({
    required String fileName,
    required drive.Media media,
    required List<String> folderIds,
    required String description,
  }) async {
    final drive.File fileMetadata =
        drive.File()
          ..name = fileName
          ..description = description
          ..parents = folderIds;

    return await _driveApi!.files.create(fileMetadata, uploadMedia: media);
  }

  // Helper method to upload or update a file
  static Future<drive.File> _uploadOrUpdateFile({
    required String fileName,
    required drive.Media media,
    required List<String> folderIds,
    required String description,
  }) async {

    drive.File? existingFile = await _findFileInFolder(
      folderIds.first,
      fileName,
    );
  
    if (existingFile != null) {
      // Update existing file
      final String fileId = existingFile.id!;
      print('Updating existing file: $fileName');

      return await _driveApi!.files.update(
        drive.File()..id = fileId..description = description,
        fileId,
        uploadMedia: media,
      );
    } else {
      // Create new file
      print('Creating new file: $fileName');

      final drive.File fileMetadata =
          drive.File()
            ..name = fileName
            ..description = description
            ..parents = folderIds;

      return await _driveApi!.files.create(fileMetadata, uploadMedia: media);
    }
  }

  // Download database from Google Drive
  static Future<bool> downloadDatabase() async {
    try {
      if (_driveApi == null) {
        bool signedIn = await signInToGoogle();
        if (!signedIn) return false;
      }

      final List<String> folderIds = await _getOrCreateBackupFolder();

      final drive.FileList fileList = await _driveApi!.files.list(
        q: "'${folderIds.first}' in parents and name contains '.db' and trashed=false",
        orderBy: 'createdTime desc',
        pageSize: 10,
      );

      if (fileList.files?.isEmpty ?? true) {
        print('No backup files found');
        return false;
      }

      final drive.File latestFile = fileList.files!.first;
      print('Downloading: ${latestFile.name}');

      final drive.Media downloadedMedia =
          await _driveApi!.files.get(
                latestFile.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/restored_database.db');

      final List<int> bytes = [];
      await for (final chunk in downloadedMedia.stream) {
        bytes.addAll(chunk);
      }

      await tempFile.writeAsBytes(bytes);

      final Database currentDb = await DatabaseHelper.database;
      await currentDb.close();

      final File currentDbFile = File(currentDb.path);
      await tempFile.copy(currentDbFile.path);
      await tempFile.delete();

      await DatabaseHelper.database;
      print('Database restored successfully');
      return true;
    } catch (e) {
      print('Error downloading database: $e');
      return false;
    }
  }

  // Get or create backup folder
  static Future<List<String>> _getOrCreateBackupFolder() async {
    try {
      print('Looking for existing backup folder...');

      // Search for existing backup folder
      final drive.FileList existingFolders = await _driveApi!.files.list(
        q: "name='Patients_DB_Backups' and mimeType='application/vnd.google-apps.folder' and trashed=false",
      );

      if (existingFolders.files?.isNotEmpty ?? false) {
        final folderId = existingFolders.files!.first.id!;
        print('Found existing backup folder: $folderId');
        return [folderId];
      }

      print('Creating new backup folder...');

      // Create new backup folder
      final drive.File folderMetadata =
          drive.File()
            ..name = 'Patients_DB_Backups'
            ..mimeType = 'application/vnd.google-apps.folder'
            ..description = 'Backup folder for Patients Database';

      final drive.File createdFolder = await _driveApi!.files.create(
        folderMetadata,
      );
      print('Created backup folder: ${createdFolder.id}');

      return [createdFolder.id!];
    } catch (e) {
      print('Error managing backup folder: $e');
      return [];
    }
  }

  // Check if signed in
  static Future<bool> isSignedIn() async {
    await initialize();
    return await _googleSignIn?.isSignedIn() ?? false;
  }

  // Get current user
  static Future<String?> getCurrentUserEmail() async {
    await initialize();
    final GoogleSignInAccount? account = await _googleSignIn?.signInSilently();
    return account?.email;
  }

  // Sign out
  static Future<void> signOut() async {
    await _googleSignIn?.signOut();
    _driveApi = null;
    print('Signed out from Google');
  }

  // Check if a file exists in Google Drive
  static Future<drive.File?> _findFileInFolder(
    String folderIds,
    String fileName,
  ) async {
    try {
      final drive.FileList files = await _driveApi!.files.list(
        q: "'$folderIds' in parents and name='$fileName' and trashed=false",
        pageSize: 1,
      );

      if (files.files?.isNotEmpty ?? false) {
        return files.files!.first;
      }
      return null;
    } catch (e) {
      print('Error searching for file: $e');
      return null;
    }
  }
}

// Custom HTTP client for Google Auth using authHeaders
class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  void close() {
    _client.close();
  }
}
