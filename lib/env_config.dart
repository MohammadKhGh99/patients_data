import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Google OAuth Configuration
  static String get googleOAuthClientId => dotenv.env['GOOGLE_OAUTH_CLIENT_ID'] ?? '';

  // Email Configuration
  static String get senderEmail => dotenv.env['SENDER_EMAIL'] ?? '';

  static String get senderPassword => dotenv.env['SENDER_PASSWORD'] ?? '';

  static String get recipientEmail => dotenv.env['RECIPIENT_EMAIL'] ?? '';

  // Database Configuration
  // static String get dbName => dotenv.env['DB_NAME'] ?? 'patients_database';

  // static int get dbVersion =>
  //     int.tryParse(dotenv.env['DB_VERSION'] ?? '1') ?? 1;

  // App Configuration
  // static String get appName =>
  //     dotenv.env['APP_NAME'] ?? 'المعالجة بالرقية الشرعية';

  static bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  static bool get hasEmailConfig => senderEmail.isNotEmpty && senderPassword.isNotEmpty;

    static bool get hasGoogleCredentials => googleOAuthClientId.isNotEmpty;

  // Google Drive Configuration
  // static String get backupFolderName =>
  //     dotenv.env['BACKUP_FOLDER_NAME'] ?? 'Patients_DB_Backups';

  static void printConfig() {
    if (debugMode) {
      print('=== Environment Configuration ===');
      // print('App Name: $appName');
      // print('DB Name: $dbName');
      // print('DB Version: $dbVersion');
      // print('Backup Folder: $backupFolderName');
      print('Debug Mode: $debugMode');
      print('Google OAuth Client ID: ${googleOAuthClientId.isNotEmpty}');
      print('Sender Email: $senderEmail');
      print('Recipient Email: $recipientEmail');
      print('Has Google Credentials: $hasGoogleCredentials');
      print('Has Email Config: $hasEmailConfig');
      print('================================');
    }
  }
}
