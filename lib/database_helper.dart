import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';

class DatabaseHelper {
  static Database? _database;

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
      سنة_الرقم_التسلسلي nvarchar(4),
      الرقم_التسلسلي nvarchar(20),
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
  }

  // Insert patient function
  static Future<void> insertPatient(Patient patient) async {
    try {
      final db = await database;

      // Insert the patient
      await db.insert(
        'patients',
        patient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Changed from ignore
      );

      print('Patient inserted successfully');

      // Get count after insertion (await instead of then)
      final patients = await getAllPatients();
      print('Total patients: $patients');
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
      patient.toMap(),
      // Ensure that the Patient has a matching id.
      where: 'الإسم الثلاثي = ? AND الرقم_التسلسلي = ? AND سنة_الرقم_التسلسلي = ?',
      // Pass the Patient's id as a whereArg to prevent SQL injection.
      whereArgs: [patient.fullName, patient.serialNumber, patient.serialNumberYear],
    );
  }

  static Future<List<Patient?>?> getPatients(
    String searchMethod,
    String? value,
  ) async {
    List<Patient?>? patients = [];
    if (searchMethod == 'الإسم الشخصي' && value != null) {
      patients = await _getPatientsByFirstName(value);
    } else if (searchMethod == 'الإسم الشخصي واسم الأب' && value != null) {
      patients = await _getPatientsByFirstMiddleName(value);
    } else if (searchMethod == 'الإسم الشخصي واسم العائلة' && value != null) {
      patients = await _getPatientsByFirstLastName(value);
    } else if (searchMethod == 'اسم العائلة' && value != null) {
      patients = await _getPatientsByLastName(value);
    } else if (searchMethod == 'الإسم الثلاثي' && value != null) {
      patients = await _getPatientsByFullName(value);
    } else if (searchMethod == 'رقم الهوية' && value != null) {
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
    String firstMiddleName,
  ) async {
    // Get a reference to the database.
    final db = await database;

    final List<String> names = firstMiddleName.split(" ");
    // Query the table for all patients by first middle name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'الإسم_الشخصي = ? AND إسم_الأب = ?',
      whereArgs: names,
    );

    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Future<List<Patient?>> _getPatientsByFirstLastName(
    String firstLastName,
  ) async {
    // Get a reference to the database.
    final db = await database;

    final List<String> names = firstLastName.split(" ");
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
}
