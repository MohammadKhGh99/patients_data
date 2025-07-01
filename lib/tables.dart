
class Patient {
  String? serialNumberYear;
  String? serialNumber;
  String? fullName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? id;
  String? gender;
  String? maritalStatus;
  String? age;
  String? children;
  String? prayer;
  String? health;
  String? work;
  String? companion;
  String? city;
  String? phoneNumber;
  String? description;
  String? diagnosis;
  String? treatment;

  Patient({
    this.serialNumberYear,
    this.serialNumber,
    this.fullName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.id,
    this.gender,
    this.maritalStatus,
    this.age,
    this.children,
    this.prayer,
    this.health,
    this.work,
    this.companion,
    this.city,
    this.phoneNumber,
    this.description,
    this.diagnosis,
    this.treatment,
  });

  // Factory constructor to create a Patient from a map
  Map<String, String?> toMap() {
    return {
      'serialNumberYear': serialNumberYear,
      'serialNumber': serialNumber,
      'fullName': fullName,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'id': id,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'age': age,
      'children': children,
      'prayer': prayer,
      'health': health,
      'work': work,
      'companion': companion,
      'city': city,
      'phoneNumber': phoneNumber,
      'description': description,
      'diagnosis': diagnosis,
      'treatment': treatment,
    };
  }

  static Patient fromMap(Map<String, Object?> map) {
    return Patient(
      serialNumberYear: map['serialNumberYear'] as String?,
      serialNumber: map['serialNumber'] as String?,
      fullName: map['fullName'] as String?,
      firstName: map['firstName'] as String?,
      middleName: map['middleName'] as String?,
      lastName: map['lastName'] as String?,
      id: map['id'] as String?,
      gender: map['gender'] as String?,
      maritalStatus: map['maritalStatus'] as String?,
      age: map['age'] as String?,
      children: map['children'] as String?,
      prayer: map['prayer'] as String?,
      health: map['health'] as String?,
      work: map['work'] as String?,
      companion: map['companion'] as String?,
      city: map['city'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      description: map['description'] as String?,
      diagnosis: map['diagnosis'] as String?,
      treatment: map['treatment'] as String?,
    );
  }

  @override
  String toString() {
    return 'Patient{serialNumberYear: $serialNumberYear, serialNumber: $serialNumber, fullName: $fullName, firstName: $firstName, middleName: $middleName, lastName: $lastName, id: $id, gender: $gender, maritalStatus: $maritalStatus, age: $age, children: $children, prayer: $prayer, health: $health, work: $work, companion: $companion, city: $city, phoneNumber: $phoneNumber, description: $description, diagnosis: $diagnosis, treatment: $treatment}';
  }
}