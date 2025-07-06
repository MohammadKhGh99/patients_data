import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'env_config.dart';

class EmailService {
  // Send database backup via email
  static Future<bool> sendDatabaseBackup({String? customRecipient}) async {
    try {
      EnvConfig.printConfig();

      if (!EnvConfig.hasEmailConfig) {
        print('Email configuration missing in .env file');
        return false;
      }

      print('Starting email backup process...');

      // Get the database file
      final Database db = await DatabaseHelper.database;
      final String dbPath = db.path;
      final File dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        print('Database file not found');
        return false;
      }

      print('Database file found, size: ${await dbFile.length()} bytes');

      // Create a copy in temp directory with timestamp
      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String backupFileName = 'patients_backup_$timestamp.db';
      final File backupFile = File('${tempDir.path}/$backupFileName');

      await dbFile.copy(backupFile.path);
      print('Backup file created: ${backupFile.path}');

      // Configure SMTP server (Gmail)
      final smtpServer = gmail(EnvConfig.senderEmail, EnvConfig.senderPassword);

      // Create message
      final message =
          Message()
            ..from = Address(EnvConfig.senderEmail, 'نظام قاعدة بيانات المرضى')
            ..recipients.add(customRecipient ?? EnvConfig.recipientEmail)
            ..subject =
                'نسخة احتياطية - قاعدة بيانات المرضى - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
            ..text = '''
السلام عليكم ورحمة الله وبركاته،

نسخة احتياطية من قاعدة بيانات المرضى مرفقة مع هذا الإيميل.

تفاصيل النسخة الاحتياطية:
- تاريخ ووقت النسخة: ${DateTime.now().toLocal()}
- حجم الملف: ${await backupFile.length()} بايت
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
    <li><strong>حجم الملف:</strong> ${await backupFile.length()} بايت</li>
    <li><strong>اسم الملف:</strong> $backupFileName</li>
  </ul>
  
  <p style="color: #D32F2F; font-weight: bold;">⚠️ يرجى حفظ هذا الملف في مكان آمن.</p>
  
  <hr style="border: 1px solid #E0E0E0; margin: 20px 0;">
  <p style="color: #666;">مع أطيب التحيات،<br><strong>نظام إدارة بيانات المرضى</strong></p>
</div>
        '''
            ..attachments = [FileAttachment(backupFile)];

      // Send email
      print('Sending email to: ${customRecipient ?? EnvConfig.recipientEmail}');
      final sendReport = await send(message, smtpServer);
      print('Email sent successfully: ${sendReport.toString()}');

      // Clean up temp file
      await backupFile.delete();
      print('Temporary file cleaned up');

      return true;
    } catch (e) {
      print('Error sending email: $e');
      print('Error type: ${e.runtimeType}');
      if (e.toString().contains('Authentication')) {
        print('Authentication failed - check email and password in .env file');
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
        print('Email configuration missing');
        return false;
      }

      final Database db = await DatabaseHelper.database;
      final String dbPath = db.path;
      final File dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        print('Database file not found');
        return false;
      }

      // Create temp backup
      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final File backupFile = File(
        '${tempDir.path}/patients_backup_$timestamp.db',
      );
      await dbFile.copy(backupFile.path);

      // Configure SMTP
      final smtpServer = gmail(EnvConfig.senderEmail, EnvConfig.senderPassword);

      // Create message
      final emailMessage =
          Message()
            ..from = Address(EnvConfig.senderEmail, 'نظام قاعدة بيانات المرضى')
            ..recipients.add(recipientEmail ?? EnvConfig.recipientEmail)
            ..subject = subject
            ..text = customMessage
            ..attachments = [FileAttachment(backupFile)];

      // Send email
      await send(emailMessage, smtpServer);

      // Clean up
      await backupFile.delete();

      return true;
    } catch (e) {
      print('Error sending custom email: $e');
      return false;
    }
  }

  // Test email configuration
  static Future<bool> testEmailConfig() async {
    try {
      if (!EnvConfig.hasEmailConfig) {
        print('Email configuration missing');
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

      await send(message, smtpServer);
      print('Test email sent successfully');
      return true;
    } catch (e) {
      print('Test email failed: $e');
      return false;
    }
  }
}
