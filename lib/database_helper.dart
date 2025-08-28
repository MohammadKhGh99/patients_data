import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';

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


     await db.execute('''
      INSERT INTO sqlite_sequence (name, seq) VALUES ('patients', 1)
    ''');

    // await db.execute('''
    //   INSERT INTO patients (الرقم_التسلسلي, الإسم_الشخصي) VALUES (1, 'dummy')
    // ''');

    // await db.execute('''
    //   DELETE FROM patients WHERE الرقم_التسلسلي = 1
    // ''');
  }

  // Insert patient function
  static Future<void> insertPatient(Patient patient) async {
    try {
      final db = await database;

      // Insert the patient
      await db.insert(
        'patients',
        patient.toMapForInsertion(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Changed from ignore
      );

      print('Patient inserted successfully');

      // Get count after insertion (await instead of then)
      final patients = await getAllPatients();
      print('Total patients: $patients');
      lastPatientSerialNumber++;
    } catch (e) {
      print('Error inserting patient: $e');
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
      where: 'الرقم_التسلسلي = ? AND السنة = ?',
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
    } else if (searchMethod == 'الإسم الشخصي') {
      patients = await _getPatientsByFirstName(value);
    } else if (searchMethod == 'الإسم الشخصي واسم الأب') {
      patients = await _getPatientsByFirstMiddleName(value, middleOrLast);
    } else if (searchMethod == 'الإسم الشخصي واسم العائلة') {
      patients = await _getPatientsByFirstLastName(value, middleOrLast);
    } else if (searchMethod == 'اسم العائلة') {
      patients = await _getPatientsByLastName(value);
    } else if (searchMethod == 'الإسم الثلاثي') {
      patients = await _getPatientsByFullName(value);
    } else if (searchMethod == 'رقم الهوية') {
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
      where: 'الإسم_الشخصي = ?',
      whereArgs: [firstName],
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsByFirstMiddleName(
    String firstName, String? middleName,
  ) async {
    // Get a reference to the database.
    final db = await database;

    final List<String?> names = [firstName, middleName];
    // Query the table for all patients by first middle name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'الإسم_الشخصي = ? AND إسم_الأب = ?',
      whereArgs: names,
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsByFirstLastName(
    String firstName, String? lastName,
  ) async {
    // Get a reference to the database.
    final db = await database;

    final List<String?> names = [firstName, lastName];
    // Query the table for all patients by first last name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'الإسم_الشخصي = ? AND إسم_العائلة = ?',
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
      where: 'إسم_العائلة = ?',
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
      where: 'الإسم الثلاثي = ?',
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
      print('Error getting next serial number: $e');
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
      print('Error getting last serial number: $e');
      return 1;
    }
  }
}
