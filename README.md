# Patient Management System (نظام إدارة بيانات المرضى)

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A comprehensive Flutter application for managing patient data with backup and synchronization capabilities. This application supports Arabic language and provides features for storing, searching, and backing up patient information.

## ✨ Features

- 📝 **Patient Management**: Add, edit, and search patient records
- 🔍 **Advanced Search**: Search patients by name, ID, phone, or other criteria
- 📊 **Data Export**: Export patient data to CSV format
- 📧 **Email Backup**: Send database backups via email
- ☁️ **Google Drive Integration**: Backup and restore data from Google Drive
- 🌐 **Arabic Support**: Full RTL (Right-to-Left) language support
- 📱 **Local Storage**: Store backups on device storage
- 🔐 **Secure Configuration**: Environment-based configuration

## 📋 Prerequisites

Before running this application, ensure you have:

- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator for testing
- Google account (for Google Drive integration)
- Gmail account (for email backup functionality)

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/MohammadKhGh99/patients_data.git
cd patients_data
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Create a `.env` file in the project root directory:

```env
# Google OAuth Configuration (for Google Drive backup)
GOOGLE_OAUTH_CLIENT_ID=your_google_oauth_client_id_here.apps.googleusercontent.com

# Email Configuration (for email backups)
SENDER_EMAIL=your_gmail_address@gmail.com
SENDER_PASSWORD=your_app_password_here
RECIPIENT_EMAIL=recipient_email@example.com

# App Configuration
DEBUG_MODE=true
BACKUP_FOLDER_NAME=المعالجة بالرقية الشرعية
```

### 4. Run the Application

```bash
flutter run
```

## ⚙️ Configuration

### Setting up Google Drive Integration

1. **Create a Google Cloud Project:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one

2. **Enable Google Drive API:**
   - Navigate to APIs & Services > Library
   - Search for "Google Drive API" and enable it

3. **Create OAuth 2.0 Credentials:**
   - Go to APIs & Services > Credentials
   - Click "Create Credentials" > "OAuth 2.0 Client ID"
   - Select "Android" as application type
   - Get your package name: `com.example.patients_data` (or your custom package)
   - Get SHA-1 fingerprint:

     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```

   - Copy the generated Client ID to your `.env` file

### Setting up Email Backup

1. **Enable 2-Factor Authentication** on your Gmail account

2. **Generate App Password:**
   - Go to [Google Account Settings](https://myaccount.google.com/)
   - Navigate to Security → 2-Step Verification → App passwords
   - Generate a new app password
   - Use this 16-character password as `SENDER_PASSWORD` (not your regular Gmail password)

### Android Permissions

The app requires the following permissions (already configured in `android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## 🏗️ Building the App

### Debug Build

```bash
flutter run
```

### Release Build

1. **Build APK:**

   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle (recommended for Play Store):**

   ```bash
   flutter build appbundle --release
   ```

3. **Build for specific architecture:**

   ```bash
   flutter build apk --target-platform android-arm64 --release
   ```

The built APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## 📁 Project Structure

```
lib/
├── main.dart                 # Main application entry point
├── add_patient.dart         # Add/Edit patient screen
├── search_patient.dart      # Patient search screen
├── search_results.dart      # Search results display
├── database_helper.dart     # SQLite database operations
├── email_service.dart       # Email backup functionality
├── google_drive_service.dart # Google Drive integration
├── tables.dart              # Data models (Patient class)
├── constants.dart           # App constants and strings
├── helpers.dart             # Utility functions
├── env_config.dart          # Environment configuration
└── utils/
    └── logger.dart          # Logging utility
```

## 📖 Usage

### Adding Patients

1. Launch the app and tap "إضافة مريض جديد" (Add New Patient)
2. Fill in the patient information:
   - Serial number and year (auto-generated)
   - Full name (first, middle, last)
   - ID number, age, gender
   - Contact information and medical details
3. Tap "حفظ" (Save) to store the patient record

### Searching Patients

1. Tap "البحث عن مريض" (Search Patient)
2. Enter search criteria (name, ID, phone, etc.)
3. Select search method from dropdown
4. View search results and tap on a patient to view/edit details

### Backup Options

1. **CSV Export**: Tap "تحويل قاعدة البيانات إلى ملف اكسل" to export data to CSV
2. **Email Backup**: Tap "إرسال قاعدة البيانات بالإيميل" to send backup via email
3. **Google Drive**: Use Google Drive buttons to backup/restore from cloud
4. **Local Storage**: Save backups directly to device storage

## 🔧 Troubleshooting

### Common Issues

1. **Google Drive Sign-in Failed (ApiException: 10):**
   - Verify your OAuth Client ID in `.env` file
   - Check SHA-1 fingerprint matches your keystore
   - Ensure Google Drive API is enabled in Google Cloud Console
   - Try without client ID first (comment it out for testing)

2. **Email Backup Failed:**
   - Use App Password, not regular Gmail password
   - Enable 2-Factor Authentication on Gmail account
   - Check sender and recipient email addresses
   - Verify internet connection

3. **Permission Denied for File Storage:**
   - Grant storage permissions in device app settings
   - Check if external storage is available
   - Try using app-specific storage as fallback

4. **Database Errors:**
   - Clear app data and restart
   - Check device storage space
   - Verify database file integrity

### Debugging

Enable debug mode in `.env` file:

```env
DEBUG_MODE=true
```

Check logs using:

```bash
flutter logs
```

The app uses structured logging with different levels:

- **INFO**: General information
- **SUCCESS**: Successful operations
- **WARNING**: Non-critical issues
- **ERROR**: Critical errors with stack traces
- **DEBUG**: Detailed debugging information

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add some feature'`
4. Push to branch: `git push origin feature-name`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:

- Create an issue in the repository
- Contact: mohammad.gh454@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for Arabic font support
- googleapis package for Google Drive integration
- mailer package for email functionality
- All contributors and testers

## ⚠️ Important Notes

- **Healthcare Compliance**: This application is designed for healthcare professionals to manage patient data. Ensure compliance with local healthcare data protection regulations (HIPAA, GDPR, etc.) when using this application.
- **Data Security**: Always use secure passwords and enable 2FA on connected accounts
- **Backup Strategy**: Regularly backup your data using multiple methods (email, Google Drive, local storage)
- **Testing**: Test all backup and restore functionality before relying on it in production

## 📊 Dependencies

Key dependencies used in this project:

```yaml
dependencies:
  flutter: sdk
  sqflite: ^2.3.0                    # Local SQLite database
  path_provider: ^2.1.1              # File system paths
  google_sign_in: ^6.1.5             # Google authentication
  googleapis: ^11.4.0                # Google APIs
  mailer: ^6.0.1                     # Email functionality
  google_fonts: ^6.1.0               # Arabic fonts
  font_awesome_flutter: ^10.6.0      # Icons
  flutter_dotenv: ^5.1.0             # Environment variables
  permission_handler: ^11.1.0        # Android permissions
  logging: ^1.2.0                    # Structured logging
```

---

**Version**: 1.0.0  
**Last Updated**: August 2024  
**Flutter Version**: 3.x+
    - Navigate to APIs & Services → Library
    - Search for "Google Drive API" and enable it
4. Create OAuth 2.0 Credentials:
    - Go to APIs & Services → Credentials
    - Click "Create Credentials" → "OAuth 2.0 Client ID"
    - Select "Android" as application type
    - Package name: `com.example.patients_data`
    - Get SHA-1 fingerprint:
      ```bash
      keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
      ```
5. Copy the generated Client ID to your `.env` file

## 🏗️ Complete .env File Template

```env
# ==============================================
# EMAIL BACKUP CONFIGURATION
# ==============================================
# Gmail account for sending database backups
SENDER_EMAIL=your-gmail@gmail.com

# Gmail App Password (NOT your regular password)
# Generate this from Google Account Settings > Security > App passwords
SENDER_PASSWORD=abcd-efgh-ijkl-mnop

# Email address to receive backup files
RECIPIENT_EMAIL=backup-storage@gmail.com

# ==============================================
# GOOGLE DRIVE INTEGRATION
# ==============================================
# OAuth 2.0 Client ID from Google Cloud Console
GOOGLE_DRIVE_CLIENT_ID=123456789-abcdefghijklmnop.apps.googleusercontent.com

# ==============================================
# APPLICATION SETTINGS
# ==============================================
# Enable/disable debug logging
DEBUG_MODE=true

# Application version
APP_VERSION=1.0.0

# Maximum backup file size in MB
MAX_BACKUP_SIZE_MB=50

# Backup retention days
BACKUP_RETENTION_DAYS=30
```

Patient Management System (نظام إدارة بيانات المرضى)
A comprehensive Flutter application for managing patient data with backup and synchronization capabilities. This application supports Arabic language and provides features for storing, searching, and backing up patient information.

Features
📝 Patient Management: Add, edit, and search patient records
🔍 Advanced Search: Search patients by name, ID, phone, or other criteria
📊 Data Export: Export patient data to CSV format
📧 Email Backup: Send database backups via email
☁️ Google Drive Integration: Backup and restore data from Google Drive
🌐 Arabic Support: Full RTL (Right-to-Left) language support
📱 Local Storage: Store backups on device storage
🔐 Secure Configuration: Environment-based configuration
Screenshots
(Add screenshots of your app here)

Prerequisites
Before running this application, ensure you have:

Flutter SDK (latest stable version)
Android Studio or VS Code with Flutter extensions
Android device or emulator for testing
Google account (for Google Drive integration)
Gmail account (for email backup functionality)
Installation
Clone the repository:

Install dependencies:

Create environment configuration: Create a .env file in the project root directory (see Configuration section below)

Run the application:

Configuration
Environment Variables
Create a .env file in the project root directory with the following variables:

Setting up Google Drive Integration
Create a Google Cloud Project:

Go to Google Cloud Console
Create a new project or select existing one
Enable Google Drive API:

Navigate to APIs & Services > Library
Search for "Google Drive API" and enable it
Create OAuth 2.0 Credentials:

Go to APIs & Services > Credentials
Click "Create Credentials" > "OAuth 2.0 Client ID"
Select "Android" as application type
Get your package name: com.example.patients_data (or your custom package)
Get SHA-1 fingerprint:
Copy the generated Client ID to your .env file
Setting up Email Backup
Enable 2-Factor Authentication on your Gmail account

Generate App Password:

Go to Google Account settings
Security > 2-Step Verification > App passwords
Generate a new app password
Use this password in the SENDER_PASSWORD field (not your regular Gmail password)
Android Permissions
The app requires the following permissions (already configured in AndroidManifest.xml):

Building the App
Debug Build
Release Build
Build APK:

Build App Bundle (recommended for Play Store):

Build for specific architecture:

The built APK will be available at: build/app/outputs/flutter-apk/app-release.apk

Project Structure
Usage
Adding Patients
Launch the app and tap "إضافة مريض جديد" (Add New Patient)
Fill in the patient information:
Serial number and year (auto-generated)
Full name (first, middle, last)
ID number, age, gender
Contact information and medical details
Tap "حفظ" (Save) to store the patient record
Searching Patients
Tap "البحث عن مريض" (Search Patient)
Enter search criteria (name, ID, phone, etc.)
View search results and tap on a patient to view/edit details
Backup Options
CSV Export: Tap "تحويل قاعدة البيانات إلى ملف اكسل" to export data to CSV
Email Backup: Tap "إرسال قاعدة البيانات بالإيميل" to send backup via email
Google Drive: Use Google Drive buttons to backup/restore from cloud
Troubleshooting
Common Issues
Google Drive Sign-in Failed:

Verify your OAuth Client ID in .env
Check SHA-1 fingerprint matches your keystore
Ensure Google Drive API is enabled
Email Backup Failed:

Use App Password, not regular Gmail password
Enable 2-Factor Authentication on Gmail account
Check sender and recipient email addresses
Permission Denied for File Storage:

Grant storage permissions in app settings
Check if external storage is available
Database Errors:

Clear app data and restart
Check device storage space
Debugging
Enable debug mode in .env file:

Check logs using:

Contributing
Fork the repository
Create a feature branch: git checkout -b feature-name
Commit changes: git commit -am 'Add some feature'
Push to branch: git push origin feature-name
Submit a pull request
License
This project is licensed under the MIT License - see the LICENSE file for details.

Support
For support and questions:

Create an issue in the repository
Contact: mohammad.gh454@gmailcom
Acknowledgments
Flutter team for the amazing framework
Google Fonts for Arabic font support
All contributors and testers
Note: This application is designed for healthcare professionals to manage patient data. Ensure compliance with local healthcare data protection regulations (HIPAA, GDPR, etc.) when using this application.
