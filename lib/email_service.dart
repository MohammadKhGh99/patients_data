import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'env_config.dart';
import 'utils/logger.dart';

class EmailService {
  // Send database backup via email
  static Future<bool> sendDatabaseBackup({String? customRecipient}) async {
    try {
      // EnvConfig.printConfig();

      if (!EnvConfig.hasEmailConfig) {
        AppLogger.error('Email configuration missing in .env file');
        return false;
      }

      AppLogger.info('Starting email backup process...');

      // Get the database file
      final Database db = await DatabaseHelper.database;
      final String dbPath = db.path;
      final File dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        AppLogger.error('Database file not found at: $dbPath');
        return false;
      }

      final fileSize = await dbFile.length();
      AppLogger.info('Database file found, size: $fileSize bytes');

      // Create a copy in temp directory with timestamp
      final Directory tempDir = await getTemporaryDirectory();
      final String backupFileName = 'patients.db';
      final File backupFile = File('${tempDir.path}/$backupFileName');

      await dbFile.copy(backupFile.path);
      AppLogger.info('Backup file created: ${backupFile.path}');

      // Configure SMTP server (Gmail)
      final smtpServer = gmail(EnvConfig.senderEmail, EnvConfig.senderPassword);

      final recipient = customRecipient ?? EnvConfig.recipientEmail;
      final fileLength = await backupFile.length();

      // Create message
      final message =
          Message()
            ..from = Address(EnvConfig.senderEmail, 'نظام قاعدة بيانات المرضى')
            ..recipients.add(recipient)
            ..subject =
                'نسخة احتياطية - قاعدة بيانات المرضى - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
            ..text = '''
السلام عليكم ورحمة الله وبركاته،

نسخة احتياطية من قاعدة بيانات المرضى مرفقة مع هذا الإيميل.

تفاصيل النسخة الاحتياطية:
- تاريخ ووقت النسخة: ${DateTime.now().toLocal()}
- حجم الملف: $fileLength بايت
- اسم الملف: $backupFileName

يرجى حفظ هذا الملف في مكان آمن.

مع أطيب التحيات،
نظام إدارة بيانات المرضى
        '''
            ..html = '''
<div dir="rtl" style="font-family: Arial, sans-serif; line-height: 1.6;">
  <h2 style="color: #2E7D32;">نسخة احتياطية - قاعدة بيانات المرضى</h2>
  <p>السلام عليكم ورحمة الله وبركاته،</p>
  <p>نسخة احتياطية من قاعدة بيانات المرضى مرفقة مع هذا الإيميل.</p>
  
  <h3 style="color: #388E3C;">تفاصيل النسخة الاحتياطية:</h3>
  <ul style="background-color: #E8F5E8; padding: 15px; border-radius: 5px;">
    <li><strong>تاريخ ووقت النسخة:</strong> ${DateTime.now().toLocal()}</li>
    <li><strong>حجم الملف:</strong> $fileLength بايت</li>
    <li><strong>اسم الملف:</strong> $backupFileName</li>
  </ul>
  
  <p style="color: #D32F2F; font-weight: bold;">⚠️ يرجى حفظ هذا الملف في مكان آمن.</p>
  
  <hr style="border: 1px solid #E0E0E0; margin: 20px 0;">
  <p style="color: #666;">مع أطيب التحيات،<br><strong>نظام إدارة بيانات المرضى</strong></p>
</div>
        '''
            ..attachments = [FileAttachment(backupFile)];

      // Send email
      AppLogger.info('Sending email to: $recipient');
      final sendReport = await send(message, smtpServer);
      AppLogger.success('Email sent successfully: ${sendReport.toString()}');

      // Clean up temp file
      await backupFile.delete();
      AppLogger.debug('Temporary file cleaned up');

      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error sending email', e, stackTrace);
      AppLogger.debug('Error type: ${e.runtimeType}');

      if (e.toString().contains('Authentication')) {
        AppLogger.error(
          'Authentication failed - check email and password in .env file',
        );
      }
      return false;
    }
  }

  // Send database with custom message
  static Future<bool> sendDatabaseWithMessage({
    required String subject,
    required String customMessage,
    String? recipientEmail,
  }) async {
    try {
      if (!EnvConfig.hasEmailConfig) {
        AppLogger.error('Email configuration missing');
        return false;
      }

      final Database db = await DatabaseHelper.database;
      final String dbPath = db.path;
      final File dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        AppLogger.error('Database file not found at: $dbPath');
        return false;
      }

      // Create temp backup
      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final File backupFile = File(
        '${tempDir.path}/patients_backup_$timestamp.db',
      );
      await dbFile.copy(backupFile.path);

      AppLogger.info('Created temporary backup: ${backupFile.path}');

      // Configure SMTP
      final smtpServer = gmail(EnvConfig.senderEmail, EnvConfig.senderPassword);

      final recipient = recipientEmail ?? EnvConfig.recipientEmail;

      // Create message
      final emailMessage =
          Message()
            ..from = Address(EnvConfig.senderEmail, 'نظام قاعدة بيانات المرضى')
            ..recipients.add(recipient)
            ..subject = subject
            ..text = customMessage
            ..attachments = [FileAttachment(backupFile)];

      // Send email
      AppLogger.info('Sending custom email to: $recipient');
      await send(emailMessage, smtpServer);
      AppLogger.success('Custom email sent successfully');

      // Clean up
      await backupFile.delete();
      AppLogger.debug('Temporary backup file cleaned up');

      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error sending custom email', e, stackTrace);
      return false;
    }
  }

  // Test email configuration
  static Future<bool> testEmailConfig() async {
    try {
      if (!EnvConfig.hasEmailConfig) {
        AppLogger.error('Email configuration missing');
        return false;
      }

      final smtpServer = gmail(EnvConfig.senderEmail, EnvConfig.senderPassword);

      final message =
          Message()
            ..from = Address(EnvConfig.senderEmail, 'نظام قاعدة بيانات المرضى')
            ..recipients.add(EnvConfig.recipientEmail)
            ..subject = 'اختبار إعدادات الإيميل'
            ..text =
                'هذه رسالة اختبار للتأكد من إعدادات الإيميل. إذا وصلتك هذه الرسالة فإن الإعدادات صحيحة.';

      AppLogger.info('Sending test email to: ${EnvConfig.recipientEmail}');
      await send(message, smtpServer);
      AppLogger.success('Test email sent successfully');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Test email failed', e, stackTrace);
      return false;
    }
  }
}
