import 'dart:io';
import 'dart:typed_data';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'database_helper.dart';
import 'env_config.dart';
import 'package:path/path.dart';
import 'utils/logger.dart'; // ✅ Add this import

class GoogleDriveService {
  static const List<String> _scopes = [
    drive.DriveApi.driveFileScope,
    drive.DriveApi.driveAppdataScope,
  ];

  static GoogleSignIn? _googleSignIn;
  static drive.DriveApi? _driveApi;
  static bool _isInitialized = false;

  // Initialize Google Sign-In
  static Future<void> initialize() async {
    if (_isInitialized) return;

    AppLogger.info('Initializing Google Drive Service...');
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
      AppLogger.debug(
        'GoogleDriveService initialized WITHOUT client ID (testing mode)',
      );
    } else {
      AppLogger.success('GoogleDriveService initialized successfully');
    }
  }

  // Sign in using authHeaders approach (more reliable)
  static Future<bool> signInToGoogle() async {
    try {
      await initialize();

      if (EnvConfig.debugMode) {
        AppLogger.debug('Starting Google Sign-In with authHeaders approach...');
      }

      // Try silent sign-in first
      GoogleSignInAccount? account = await _googleSignIn!.signInSilently();

      if (account == null) {
        if (EnvConfig.debugMode) {
          AppLogger.debug(
            'Silent sign-in failed, trying interactive sign-in...',
          );
        }
        account = await _googleSignIn!.signIn();
      }

      if (account == null) {
        AppLogger.warning('Google Sign-In cancelled by user');
        return false;
      }

      if (EnvConfig.debugMode) {
        AppLogger.info('Signed in as: ${account.email}');
        AppLogger.debug('Getting auth headers...');
      }

      try {
        // Use authHeaders instead of access tokens (more reliable)
        final Map<String, String> authHeaders = await account.authHeaders;

        if (EnvConfig.debugMode) {
          AppLogger.debug(
            'Auth headers received: ${authHeaders.keys.toList()}',
          );
          AppLogger.debug('Auth headers count: ${authHeaders.length}');
        }

        if (authHeaders.isEmpty) {
          AppLogger.error('No auth headers received');
          return false;
        }

        // Create authenticated HTTP client using authHeaders
        final http.Client httpClient = _GoogleAuthClient(authHeaders);
        _driveApi = drive.DriveApi(httpClient);

        // Test the API connection
        if (EnvConfig.debugMode) {
          AppLogger.debug('Testing Drive API connection...');
        }

        final about = await _driveApi!.about.get($fields: 'user');

        if (EnvConfig.debugMode) {
          AppLogger.success('Drive API connection successful!');
          AppLogger.info('User: ${about.user?.displayName}');
          AppLogger.info('Email: ${about.user?.emailAddress}');
        }

        AppLogger.success('Google Sign-In completed successfully');
        return true;
      } catch (e, stackTrace) {
        AppLogger.error('Auth headers error', e, stackTrace);
        AppLogger.warning('This might be a scope or API permission issue');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error signing in to Google', e, stackTrace);
      AppLogger.debug('Error type: ${e.runtimeType}');

      if (e.toString().contains('DEVELOPER_ERROR')) {
        AppLogger.error('DEVELOPER_ERROR: Try without client ID first');
      } else if (e.toString().contains('NETWORK_ERROR')) {
        AppLogger.error('NETWORK_ERROR: Check internet connection');
      } else if (e.toString().contains('SIGN_IN_REQUIRED')) {
        AppLogger.warning('User needs to sign in again');
      }

      return false;
    }
  }

  // Upload database to Google Drive (simplified version)
  static Future<bool> uploadDatabase() async {
    try {
      if (_driveApi == null) {
        AppLogger.error('Drive API not initialized');
        return false;
      }

      AppLogger.info('Starting database upload to Google Drive...');

      final dbPath = join(await getDatabasesPath(), 'patients.db');
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        AppLogger.error('Database file not found at: $dbPath');
        return false;
      }

      final fileSize = await dbFile.length();
      AppLogger.info('Database file found, size: $fileSize bytes');

      // Check if file already exists
      AppLogger.debug('Checking for existing files...');
      final existingFiles = await _driveApi!.files.list(
        q: "name='patients.db' and trashed=false",
        spaces: 'drive',
      );

      // ✅ If file exists, delete it first
      if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
        AppLogger.info(
          'Found ${existingFiles.files!.length} existing file(s), deleting...',
        );

        for (var file in existingFiles.files!) {
          await _driveApi!.files.delete(file.id!);
          AppLogger.debug('Deleted file: ${file.name} (ID: ${file.id})');
        }
        AppLogger.success('Existing files deleted successfully');
      } else {
        AppLogger.info('No existing files found');
      }

      // ✅ Create new file
      AppLogger.info('Creating new database backup...');

      final media = drive.Media(
        dbFile.openRead(),
        await dbFile.length(),
        contentType: 'application/x-sqlite3',
      );

      final List<String> folderIds = await _getOrCreateBackupFolder();

      if (folderIds.isEmpty) {
        AppLogger.error('Failed to create or find backup folder');
        return false;
      }

      final fileMetadata =
          drive.File()
            ..name = 'patients.db'
            ..description =
                'Patient database backup - ${DateTime.now().toIso8601String()}'
            ..parents = folderIds;

      final uploadedFile = await _driveApi!.files.create(
        fileMetadata,
        uploadMedia: media,
      );

      AppLogger.success('Database uploaded successfully');
      AppLogger.info('File ID: ${uploadedFile.id}');
      AppLogger.info('File Name: ${uploadedFile.name}');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error uploading database', e, stackTrace);
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
    AppLogger.debug('Uploading new file: $fileName');

    final drive.File fileMetadata =
        drive.File()
          ..name = fileName
          ..description = description
          ..parents = folderIds;

    final result = await _driveApi!.files.create(
      fileMetadata,
      uploadMedia: media,
    );
    AppLogger.success('File uploaded successfully: $fileName');
    return result;
  }

  // Helper method to upload or update a file
  static Future<drive.File> _uploadOrUpdateFile({
    required String fileName,
    required drive.Media media,
    required List<String> folderIds,
    required String description,
  }) async {
    AppLogger.debug('Checking if file exists: $fileName');

    drive.File? existingFile = await _findFileInFolder(
      folderIds.first,
      fileName,
    );

    if (existingFile != null) {
      // Update existing file
      final String fileId = existingFile.id!;
      AppLogger.info('Updating existing file: $fileName (ID: $fileId)');

      final result = await _driveApi!.files.update(
        drive.File()
          ..id = fileId
          ..description = description,
        fileId,
        uploadMedia: media,
      );

      AppLogger.success('File updated successfully: $fileName');
      return result;
    } else {
      // Create new file
      AppLogger.info('Creating new file: $fileName');

      final drive.File fileMetadata =
          drive.File()
            ..name = fileName
            ..description = description
            ..parents = folderIds;

      final result = await _driveApi!.files.create(
        fileMetadata,
        uploadMedia: media,
      );
      AppLogger.success('New file created successfully: $fileName');
      return result;
    }
  }

  // Download database from Google Drive
  static Future<bool> downloadDatabase() async {
    try {
      if (_driveApi == null) {
        AppLogger.warning(
          'Drive API not initialized, attempting to sign in...',
        );
        bool signedIn = await signInToGoogle();
        if (!signedIn) {
          AppLogger.error('Failed to sign in to Google Drive');
          return false;
        }
      }

      AppLogger.info('Starting database download from Google Drive...');

      final List<String> folderIds = await _getOrCreateBackupFolder();

      if (folderIds.isEmpty) {
        AppLogger.error('Failed to find backup folder');
        return false;
      }

      AppLogger.debug('Searching for database files in backup folder...');
      final drive.FileList fileList = await _driveApi!.files.list(
        q: "'${folderIds.first}' in parents and name contains '.db' and trashed=false",
        orderBy: 'createdTime desc',
        pageSize: 10,
      );

      if (fileList.files?.isEmpty ?? true) {
        AppLogger.warning('No backup files found in Google Drive');
        return false;
      }

      final drive.File latestFile = fileList.files!.first;
      AppLogger.info('Found ${fileList.files!.length} backup file(s)');
      AppLogger.info(
        'Downloading latest: ${latestFile.name} (${latestFile.createdTime})',
      );

      final drive.Media downloadedMedia =
          await _driveApi!.files.get(
                latestFile.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/restored_database.db');

      AppLogger.debug('Saving downloaded data to temporary file...');
      final List<int> bytes = [];
      await for (final chunk in downloadedMedia.stream) {
        bytes.addAll(chunk);
      }

      await tempFile.writeAsBytes(bytes);
      AppLogger.info('Downloaded ${bytes.length} bytes to temporary file');

      // Close current database and replace it
      AppLogger.debug('Replacing current database...');
      final Database currentDb = await DatabaseHelper.database;
      await currentDb.close();

      final File currentDbFile = File(currentDb.path);
      await tempFile.copy(currentDbFile.path);
      await tempFile.delete();

      // Reinitialize database
      await DatabaseHelper.database;
      AppLogger.success('Database restored successfully from Google Drive');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error downloading database from Google Drive',
        e,
        stackTrace,
      );
      return false;
    }
  }

  // Get or create backup folder
  static Future<List<String>> _getOrCreateBackupFolder() async {
    try {
      AppLogger.debug('Looking for existing backup folder...');

      // Search for existing backup folder
      final drive.FileList existingFolders = await _driveApi!.files.list(
        q: "name='المعالجة بالرقية الشرعية' and mimeType='application/vnd.google-apps.folder' and trashed=false",
      );

      if (existingFolders.files?.isNotEmpty ?? false) {
        final folderId = existingFolders.files!.first.id!;
        final folderName = existingFolders.files!.first.name!;
        AppLogger.success(
          'Found existing backup folder: $folderName (ID: $folderId)',
        );
        return [folderId];
      }

      AppLogger.info('No existing backup folder found, creating new one...');

      // Create new backup folder
      final drive.File folderMetadata =
          drive.File()
            ..name = 'المعالجة بالرقية الشرعية'
            ..mimeType = 'application/vnd.google-apps.folder'
            ..description =
                'Backup folder for Patients Database - Created ${DateTime.now().toIso8601String()}';

      final drive.File createdFolder = await _driveApi!.files.create(
        folderMetadata,
      );

      AppLogger.success(
        'Created backup folder: ${createdFolder.name} (ID: ${createdFolder.id})',
      );
      return [createdFolder.id!];
    } catch (e, stackTrace) {
      AppLogger.error('Error managing backup folder', e, stackTrace);
      return [];
    }
  }

  // Check if signed in
  static Future<bool> isSignedIn() async {
    try {
      await initialize();
      final isSignedIn = await _googleSignIn?.isSignedIn() ?? false;

      if (EnvConfig.debugMode) {
        AppLogger.debug(
          'Google Sign-In status: ${isSignedIn ? "Signed In" : "Not Signed In"}',
        );
      }

      return isSignedIn;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking sign-in status', e, stackTrace);
      return false;
    }
  }

  // Get current user
  static Future<String?> getCurrentUserEmail() async {
    try {
      await initialize();
      final GoogleSignInAccount? account =
          await _googleSignIn?.signInSilently();

      if (account != null) {
        AppLogger.info('Current Google user: ${account.email}');
        return account.email;
      } else {
        AppLogger.debug('No current Google user found');
        return null;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error getting current user email', e, stackTrace);
      return null;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut();
      _driveApi = null;
      AppLogger.success('Signed out from Google Drive successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Error signing out from Google', e, stackTrace);
    }
  }

  // Check if a file exists in Google Drive
  static Future<drive.File?> _findFileInFolder(
    String folderIds,
    String fileName,
  ) async {
    try {
      AppLogger.debug('Searching for file: $fileName in folder: $folderIds');

      final drive.FileList files = await _driveApi!.files.list(
        q: "'$folderIds' in parents and name='$fileName' and trashed=false",
        pageSize: 1,
      );

      if (files.files?.isNotEmpty ?? false) {
        final foundFile = files.files!.first;
        AppLogger.debug('File found: ${foundFile.name} (ID: ${foundFile.id})');
        return foundFile;
      }

      AppLogger.debug('File not found: $fileName');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error searching for file: $fileName', e, stackTrace);
      return null;
    }
  }

  // ✅ Add method to test Google Drive connection
  static Future<bool> testConnection() async {
    try {
      AppLogger.info('Testing Google Drive connection...');

      if (_driveApi == null) {
        AppLogger.warning(
          'Drive API not initialized, attempting to sign in...',
        );
        final signedIn = await signInToGoogle();
        if (!signedIn) {
          AppLogger.error('Failed to sign in for connection test');
          return false;
        }
      }

      // Test by getting user info
      final about = await _driveApi!.about.get($fields: 'user,storageQuota');

      AppLogger.success('Google Drive connection test successful');
      AppLogger.info('User: ${about.user?.displayName ?? "Unknown"}');
      AppLogger.info('Email: ${about.user?.emailAddress ?? "Unknown"}');

      if (about.storageQuota != null) {
        final usedGB = (int.tryParse(about.storageQuota!.usage?.toString() ?? '0') ?? 0) / (1024 * 1024 * 1024);
        final limitGB = (int.tryParse(about.storageQuota!.limit?.toString() ?? '0') ?? 0) / (1024 * 1024 * 1024);
        AppLogger.info(
          'Storage: ${usedGB.toStringAsFixed(2)} GB / ${limitGB.toStringAsFixed(2)} GB used',
        );
      }

      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Google Drive connection test failed', e, stackTrace);
      return false;
    }
  }

  // ✅ Add method to list backup files
  static Future<List<drive.File>> listBackupFiles() async {
    try {
      if (_driveApi == null) {
        AppLogger.error('Drive API not initialized');
        return [];
      }

      AppLogger.info('Listing backup files...');

      final List<String> folderIds = await _getOrCreateBackupFolder();
      if (folderIds.isEmpty) {
        AppLogger.error('No backup folder found');
        return [];
      }

      final drive.FileList fileList = await _driveApi!.files.list(
        q: "'${folderIds.first}' in parents and trashed=false",
        orderBy: 'createdTime desc',
        pageSize: 50,
        $fields: 'files(id,name,size,createdTime,modifiedTime)',
      );

      final files = fileList.files ?? [];
      AppLogger.info('Found ${files.length} backup files');

      for (var file in files) {
        AppLogger.debug(
          'File: ${file.name}, Size: ${file.size}, Created: ${file.createdTime}',
        );
      }

      return files;
    } catch (e, stackTrace) {
      AppLogger.error('Error listing backup files', e, stackTrace);
      return [];
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
