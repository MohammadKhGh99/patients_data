import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';
import 'constants.dart';
import 'utils/logger.dart';

class DatabaseHelper {
  static Database? _database;
  static int lastPatientSerialNumber = 2;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'patients.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
      الرقم_التسلسلي INTEGER PRIMARY KEY AUTOINCREMENT,
      السنة nvarchar(4),
      الإسم_الثلاثي nvarchar(45),
      الإسم_الشخصي nvarchar(15),
      إسم_الأب nvarchar(15),
      إسم_العائلة nvarchar(15),
      رقم_الهوية nvarchar(9),
      الجنس nvarchar(7),
      الحالة_الإجتماعية nvarchar(15),
      العمر nvarchar(3),
      أولاد nvarchar(3),
      صلاة nvarchar(5),
      صحة nvarchar(30),
      العمل nvarchar(30),
      المرافق nvarchar(30),
      البلد nvarchar(20),
      الهاتف nvarchar(12),
      وصف_الحالة nvarchar(200),
      التشخيص nvarchar(100),
      العلاج nvarchar(400)
      )
    ''');

    // Set AUTOINCREMENT to start from 2
    await db.execute('''
      INSERT INTO sqlite_sequence (name, seq) VALUES ('patients', 1)
    ''');
    
    AppLogger.success('Database created with AUTOINCREMENT starting from 2');
  }

  // Insert patient function
  static Future<void> insertPatient(Patient patient) async {
    try {
      final db = await database;

      // Insert the patient
      await db.insert(
        'patients',
        patient.toMapForInsertion(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      AppLogger.success('Patient inserted successfully, patient name: ${patient.fullName}');

      final patients = await getAllPatients();
      AppLogger.info('Total patients: ${patients.length}');
    } catch (e, stackTrace) {
      AppLogger.error('Error inserting patient', e, stackTrace);
      rethrow;
    }
  }

  // Get all patients
  static Future<List<Patient>> getAllPatients() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query('patients');
    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  // Update patient
  static Future<void> updatePatient(Patient patient) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Patient.
    await db.update(
      'patients',
      patient.toMapForInsertion(),
      // Ensure that the Patient has a matching id.
      where: '$serialNumber = ? AND $yearText = ?',
      // Pass the Patient's id as a whereArg to prevent SQL injection.
      whereArgs: [patient.serialNumber, patient.serialNumberYear],
    );
  }

  static Future<List<Patient?>?> getPatients(
    String searchMethod,
    String? value,
    String? middleOrLast,
  ) async {
    List<Patient?>? patients = [];
    if (value == null || value == "") {
      patients = await getAllPatients();
    } else if (searchMethod == firstNameText) {
      patients = await _getPatientsByFirstName(value);
    } else if (searchMethod == '$firstNameText و$middleNameText') {
      patients = await _getPatientsByFirstMiddleName(value, middleOrLast);
    } else if (searchMethod == '$firstNameText و$lastNameText') {
      patients = await _getPatientsByFirstLastName(value, middleOrLast);
    } else if (searchMethod == lastNameText) {
      patients = await _getPatientsByLastName(value);
    } else if (searchMethod == fullNameText) {
      patients = await _getPatientsByFullName(value);
    } else if (searchMethod == idNumberText) {
      patients = await _getPatientsById(value);
    } else {
      return null;
    }

    return patients;
  }

  static Future<List<Patient?>> _getPatientsByFirstName(
    String firstName,
  ) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all patients by first name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: '$firstName = ?',
      whereArgs: [firstName],
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsByFirstMiddleName(
    String firstName,
    String? middleName,
  ) async {
    // Get a reference to the database.
    final db = await database;

    final List<String?> names = [firstName, middleName];
    // Query the table for all patients by first middle name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: '$firstName = ? AND $middleName = ?',
      whereArgs: names,
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsByFirstLastName(
    String firstName,
    String? lastName,
  ) async {
    // Get a reference to the database.
    final db = await database;

    final List<String?> names = [firstName, lastName];
    // Query the table for all patients by first last name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: '$firstName = ? AND $lastName = ?',
      whereArgs: names,
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsByLastName(String lastName) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all patients by last name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: '$lastName = ?',
      whereArgs: [lastName],
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsByFullName(String fullName) async {
    // Get a reference to the database.
    final db = await database;

    // List<String> names = fullName.split(" ");
    // Query the table for all patients by full name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: '$fullName = ?',
      whereArgs: [fullName],
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsById(String id) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all patients by ID.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'رقم_الهوية = ?',
      whereArgs: [id],
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<int> getPatientsCount() async {
    return (await getAllPatients()).length + 2;
  }

  // ✅ Get the next serial number that will be used
  static Future<int> getNextSerialNumber() async {
    try {
      final db = await database;

      // Get the current sequence value
      final List<Map<String, Object?>> result = await db.rawQuery(
        'SELECT seq FROM sqlite_sequence WHERE name = ?',
        ['patients'],
      );

      if (result.isNotEmpty) {
        int currentSeq = result.first['seq'] as int;
        return currentSeq + 1; // Next number will be current + 1
      } else {
        return 2; // If no sequence found, start from 2
      }
    } catch (e) {
      // logging
      AppLogger.error('Error getting next serial number: $e');
      return 2;
    }
  }

  static Future<int> getLastSerialNumber() async {
    try {
      final db = await database;

      final List<Map<String, Object?>> result = await db.rawQuery(
        'SELECT MAX(الرقم_التسلسلي) as last_serial FROM patients',
      );

      if (result.isNotEmpty && result.first['last_serial'] != null) {
        return result.first['last_serial'] as int;
      } else {
        return 1; // No patients yet
      }
    } catch (e) {
      AppLogger.error('Error getting last serial number: $e');
      return 1;
    }
  }

  // Get column names from the patients table
  static Future<List<String>> _getColumnNames() async {
    try {
      final db = await database;

      final List<Map<String, Object?>> result = await db.rawQuery(
        'PRAGMA table_info(patients)',
      );

      // Extract column names from the result
      List<String> columnNames =
          result.map((row) => row['name'] as String).toList();

      return columnNames;
    } catch (e) {
      AppLogger.error('Error getting column names: $e');
      return [];
    }
  }

  static Future<String> generateCSVFromDatabase() async {
    try {
      final patients = await getAllPatients();
      final csvBuffer = StringBuffer();

      // Add headers
      List<String> headers = await _getColumnNames();
      csvBuffer.writeln(headers.join(','));

      // Add patient data
      for (var patient in patients) {
        csvBuffer.writeln(patient.toCsvRow());
      }

      // ✅ Save to both app directory and main storage
      await _saveCSVToMultipleLocations(csvBuffer.toString());

      return csvBuffer.toString();
    } catch (e) {
      AppLogger.error('Error generating CSV: $e');
      return '';
    }
  }

  // ✅ Helper method to save CSV to multiple locations
  static Future<void> _saveCSVToMultipleLocations(String csvContent) async {
    try {
      // 1. Save to app documents (existing functionality)
      final appDirectory = await getApplicationDocumentsDirectory();
      final appPath = '${appDirectory.path}/patients.csv';
      final appFile = File(appPath);
      await appFile.writeAsString(csvContent);
      AppLogger.error('✅ CSV saved to app directory: $appPath');

      // 2. ✅ Save to main storage Documents folder
      final mainStorageSuccess = await _copyCSVToMainStorage(csvContent);
      if (mainStorageSuccess) {
        AppLogger.error('✅ CSV copied to main storage Documents folder');
      } else {
        AppLogger.error('❌ Failed to copy CSV to main storage');
      }
    } catch (e) {
      AppLogger.error('❌ Error saving CSV: $e');
    }
  }

  // ✅ Copy CSV to main storage Documents folder
  static Future<bool> _copyCSVToMainStorage(String csvContent) async {
    try {
      // Request storage permission
      // Note: Add permission_handler dependency if not already added
      // final permission = await Permission.storage.request();
      // if (!permission.isGranted) {
      //   AppLogger.error('❌ Storage permission denied');
      //   return false;
      // }

      // Get external storage directory
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        AppLogger.error('❌ External storage not available');
        return false;
      }
      print(externalDir.path);

      // Navigate to main storage root (removes /Android/data/... part)
      String mainStoragePath = externalDir.path.split('Android')[0];

      // Create Documents folder path
      String documentsPath = '${mainStoragePath}Documents';
      Directory documentsDir = Directory(documentsPath);

      // Create Documents directory if it doesn't exist
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      // Create timestamp for unique filename
      final timestamp =
          DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final fileName = 'patients.csv';

      // Save CSV file
      final csvFile = File('$documentsPath/$fileName');
      await csvFile.writeAsString(csvContent);

      AppLogger.error('✅ CSV saved to main storage: ${csvFile.path}');
      return true;
    } catch (e) {
      AppLogger.error('❌ Error copying CSV to main storage: $e');
      return false;
    }
  }
}
