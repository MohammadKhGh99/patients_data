import 'dart:developer' as developer;
import 'package:logging/logging.dart';

class AppLogger {
  static final Logger _logger = Logger('PatientsDataApp');

  static void setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      developer.log(
        '${record.message}',
        name: record.loggerName,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  static void success(String message) {
    _logger.info('✅ $message');
  }

  static void failure(String message) {
    _logger.severe('❌ $message');
  }
}
