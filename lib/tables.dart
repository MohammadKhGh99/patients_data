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
      'السنة': serialNumberYear,
      'الرقم_التسلسلي': serialNumber,
      'الإسم_الثلاثي': fullName,
      'الإسم_الشخصي': firstName,
      'إسم_الأب': middleName,
      'إسم_العائلة': lastName,
      'رقم_الهوية': id,
      'الجنس': gender,
      'الحالة_الإجتماعية': maritalStatus,
      'العمر': age,
      'أولاد': children,
      'صلاة': prayer,
      'صحة': health,
      'العمل': work,
      'المرافق': companion,
      'البلد': city,
      'الهاتف': phoneNumber,
      'وصف_الحالة': description,
      'التشخيص': diagnosis,
      'العلاج': treatment,
    };
  }

  Map<String, String?> toMapForInsertion() {
    return {
      'السنة': serialNumberYear,
      // 'الرقم_التسلسلي': serialNumber,
      'الإسم_الثلاثي': fullName,
      'الإسم_الشخصي': firstName,
      'إسم_الأب': middleName,
      'إسم_العائلة': lastName,
      'رقم_الهوية': id,
      'الجنس': gender,
      'الحالة_الإجتماعية': maritalStatus,
      'العمر': age,
      'أولاد': children,
      'صلاة': prayer,
      'صحة': health,
      'العمل': work,
      'المرافق': companion,
      'البلد': city,
      'الهاتف': phoneNumber,
      'وصف_الحالة': description,
      'التشخيص': diagnosis,
      'العلاج': treatment,
    };
  }

  static Patient fromMap(Map<String, Object?> map) {
    return Patient(
      serialNumberYear: map['السنة'] as String?,
      serialNumber: map['الرقم_التسلسلي'].toString() as String?,
      fullName: map['الإسم_الثلاثي'] as String?,
      firstName: map['الإسم_الشخصي'] as String?,
      middleName: map['إسم_الأب'] as String?,
      lastName: map['إسم_العائلة'] as String?,
      id: map['رقم_الهوية'] as String?,
      gender: map['الجنس'] as String?,
      maritalStatus: map['الحالة_الإجتماعية'] as String?,
      age: map['العمر'] as String?,
      children: map['أولاد'] as String?,
      prayer: map['صلاة'] as String?,
      health: map['صحة'] as String?,
      work: map['العمل'] as String?,
      companion: map['المرافق'] as String?,
      city: map['البلد'] as String?,
      phoneNumber: map['الهاتف'] as String?,
      description: map['وصف_الحالة'] as String?,
      diagnosis: map['التشخيص'] as String?,
      treatment: map['العلاج'] as String?,
    );
  }

  @override
  String toString() {
    return 'Patient{serialNumberYear: $serialNumberYear, serialNumber: $serialNumber, fullName: $fullName, firstName: $firstName, middleName: $middleName, lastName: $lastName, id: $id, gender: $gender, maritalStatus: $maritalStatus, age: $age, children: $children, prayer: $prayer, health: $health, work: $work, companion: $companion, city: $city, phoneNumber: $phoneNumber, description: $description, diagnosis: $diagnosis, treatment: $treatment}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patient &&
        other.serialNumberYear == serialNumberYear &&
        other.serialNumber == serialNumber &&
        other.fullName == fullName &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.id == id &&
        other.gender == gender &&
        other.maritalStatus == maritalStatus &&
        other.age == age &&
        other.children == children &&
        other.prayer == prayer &&
        other.health == health &&
        other.work == work &&
        other.companion == companion &&
        other.city == city &&
        other.phoneNumber == phoneNumber &&
        other.description == description &&
        other.diagnosis == diagnosis &&
        other.treatment == treatment;
  }

  @override
  int get hashCode {
    return Object.hash(
      serialNumberYear,
      serialNumber,
      fullName,
      firstName,
      middleName,
      lastName,
      id,
      gender,
      maritalStatus,
      age,
      children,
      prayer,
      health,
      work,
      companion,
      city,
      phoneNumber,
      description,
      diagnosis,
      treatment,
    );
  }

  // ✅ Fix: Return a properly formatted CSV row string
  String toCsvRow() {
    List<String> rowData = [
      serialNumberYear ?? '',
      serialNumber ?? '',
      fullName ?? '',
      firstName ?? '',
      middleName ?? '',
      lastName ?? '',
      id ?? '',
      gender ?? '',
      maritalStatus ?? '',
      age ?? '',
      children ?? '',
      prayer ?? '',
      health ?? '',
      work ?? '',
      companion ?? '',
      city ?? '',
      phoneNumber ?? '',
      description ?? '',
      diagnosis ?? '',
      treatment ?? '',
    ];

    // // ✅ Escape commas and quotes, then join with commas
    // List<String> escapedData =
    //     rowData.map((cell) {
    //       String cleanCell = cell.replaceAll(',', ';').replaceAll('"', '""');
    //       return '"$cleanCell"'; // Wrap in quotes for CSV safety
    //     }).toList();
    print(rowData); // Debug: Check the escaped data format
    return rowData.join(','); // ✅ Return as comma-separated string
  }
}
