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
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _createDatabase
      );
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
    final db = await database;
    await db.insert(
      'patients',
      patient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    // Close the database after insertion
    db.close();
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
      where: 'id = ?',
      // Pass the Patient's id as a whereArg to prevent SQL injection.
      whereArgs: [patient.id],
    );
  }

  static Future<Patient?> getPatient(
    String? firstName,
    String? firstMiddleName,
    String? firstLastName,
    String? lastName,
    String? fullName,
    String? id,
  ) async {


    // if (firstName != null) {
    //   return _getPatientByFirstName(firstName);
    // } else if (firstMiddleName != null) {
    //   return _getPatientByFirstMiddleName(firstMiddleName);
    // } else if (firstLastName != null) {
    //   return _getPatientByFirstLastName(firstLastName);
    // } else if (lastName != null) {
    //   return _getPatientByLastName(lastName);
    // } else if (fullName != null) {
    //   return _getPatientByFullName(fullName);
    // } else if (id != null) {
    //   return _getPatientById(id);
    // } else {
    //   return null;
    // }


    // Query the table for a specific patient.
    final lookups = <String, dynamic>{
      'firstName': firstName,
      'firstMiddleName': firstMiddleName,
      'firstLastName': firstLastName,
      'lastName': lastName,
      'fullName': fullName,
      'id': id,
    };

    final functions = <String, Future<Patient?> Function(dynamic)>{
      'firstName': (value) => _getPatientByFirstName(value as String),
      'firstMiddleName': (value) => _getPatientByFirstMiddleName(value as String),
      'firstLastName': (value) => _getPatientByFirstLastName(value as String),
      'lastName': (value) => _getPatientByLastName(value as String),
      'fullName': (value) => _getPatientByFullName(value as String),
      'id': (value) => _getPatientById(value as String),
    };

    for (final entry in lookups.entries) {
      if (entry.value != null) {
        return await functions[entry.key]!(entry.value);
      }
    }
    return null;
  }

  static Future<Patient?> _getPatientByFirstName(String firstName) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for a specific patient by first name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'الإسم_الشخصي = ?',
      whereArgs: [firstName],
    );
    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }
    return null;
  }

  static Future<Patient?> _getPatientByFirstMiddleName(String firstMiddleName) async {
    // Get a reference to the database.
    final db = await database;

    final List<String> names = firstMiddleName.split(" ");
    // Query the table for a specific patient by first middle name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'الإسم_الشخصي = ? AND إسم_الأب = ?',
      whereArgs: names,
    );
    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }
    return null;
  }

  static Future<Patient?> _getPatientByFirstLastName(String firstLastName) async {
    // Get a reference to the database.
    final db = await database;

    final List<String> names = firstLastName.split(" ");
    // Query the table for a specific patient by first last name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'الإسم_الشخصي = ? AND إسم_العائلة = ?',
      whereArgs: names,
    );
    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }
    return null;
  }

  static Future<Patient?> _getPatientByLastName(String lastName) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for a specific patient by last name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'إسم_العائلة = ?',
      whereArgs: [lastName],
    );
    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }
    return null;
  }

  static Future<Patient?> _getPatientByFullName(String fullName) async {
    // Get a reference to the database.
    final db = await database;

    List<String> names = fullName.split(" ");
    // Query the table for a specific patient by full name.
    final List<Map<String, Object?>> maps = await db.query(
      'patients',
      where: 'الإسم_الشخصي = ? AND إسم_الأب = ? AND إسم_العائلة = ?',
      whereArgs: names,
    );
    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }
    return null;
  }

  static Future<Patient?> _getPatientById(String id) async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for a specific patient by ID.
      final List<Map<String, Object?>> maps = await db.query(
        'patients',
        where: 'رقم_الهوية = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Patient.fromMap(maps.first);
      }
      return null;
    }
    

}
