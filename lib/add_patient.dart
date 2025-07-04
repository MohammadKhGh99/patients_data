import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// Use alias to avoid conflict
import 'tables.dart';
import 'database_helper.dart';
import 'helpers.dart';

class AddPatientPage extends StatefulWidget {
  final Function(int) onButtonPressed;
  final Patient? curPatient;

  const AddPatientPage({super.key, required this.onButtonPressed, this.curPatient});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  String? _selectedGender = '---';
  String? _selectedPrayer = '---';
  String? _selectedMaritalStatus = '---';

  // Add TextEditingControllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _companionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _serialNumberYearController =
      TextEditingController();
  final TextEditingController _childrenController = TextEditingController();

  // Add FocusNodes for each field
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _workFocusNode = FocusNode();
  final FocusNode _healthFocusNode = FocusNode();
  final FocusNode _companionFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _diagnosisFocusNode = FocusNode();
  final FocusNode _treatmentFocusNode = FocusNode();
  final FocusNode _serialNumberFocusNode = FocusNode();
  final FocusNode _serialNumberYearFocusNode = FocusNode();
  final FocusNode _childrenFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current patient data if available
    print('Initializing AddPatientPage with current patient: ${widget.curPatient}');
    if (widget.curPatient != null) {
      final patient = widget.curPatient!;

      _nameController.text = patient.fullName ?? '';
      _idController.text = patient.id ?? '';
      _ageController.text = patient.age ?? '';
      _cityController.text = patient.city ?? '';
      _phoneController.text = patient.phoneNumber ?? '';
      _workController.text = patient.work ?? '';
      _healthController.text = patient.health ?? '';
      _companionController.text = patient.companion ?? '';
      _descriptionController.text = patient.description ?? '';
      _diagnosisController.text = patient.diagnosis ?? '';
      _treatmentController.text = patient.treatment ?? '';
      _serialNumberController.text = patient.serialNumber ?? '';
      _serialNumberYearController.text = patient.serialNumberYear ?? '';
      _childrenController.text = patient.children ?? '';

      // Set dropdown values based on current patient data
      setState(() {
        _selectedGender = patient.gender ?? '---';
        _selectedPrayer = patient.prayer ?? '---';
        _selectedMaritalStatus = patient.maritalStatus ?? '---';
      });
    }
  }

  @override
  void dispose() {
    // Dispose TextEditingControllers when the widget is removed
    _nameController.dispose();
    _idController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _workController.dispose();
    _healthController.dispose();
    _companionController.dispose();
    _descriptionController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _serialNumberController.dispose();
    _serialNumberYearController.dispose();
    _childrenController.dispose();

    // Dispose FocusNodes when the widget is removed
    _nameFocusNode.dispose();
    _idFocusNode.dispose();
    _ageFocusNode.dispose();
    _genderFocusNode.dispose();
    _diagnosisFocusNode.dispose();
    _treatmentFocusNode.dispose();
    _serialNumberFocusNode.dispose();
    _serialNumberYearFocusNode.dispose();
    _countryFocusNode.dispose();
    _phoneFocusNode.dispose();
    _workFocusNode.dispose();
    _healthFocusNode.dispose();
    _companionFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _childrenFocusNode.dispose();
    super.dispose();
  }

  void _addPatientToDatabase() async {
    try {
      // Create a new Patient object with the data from the text fields
      // Get all the values
      String serialNumberYear = _serialNumberYearController.text;
      String serialNumber = _serialNumberController.text;
      String fullName = _nameController.text;

      List<String> nameParts = fullName.split(' ');
      String first = nameParts.isNotEmpty ? nameParts[0] : '';
      String middle = nameParts.length > 1 ? nameParts[1] : '';
      String last = nameParts.length > 2 ? nameParts[2] : '';

      // If there are more than 3 parts, join the rest as last name
      if (nameParts.length > 3) {
        last = nameParts.sublist(3).join(' ');
      }

      String id = _idController.text;
      String gender = _selectedGender ?? '---';
      String maritalStatus = _selectedMaritalStatus ?? '---';
      String age = _ageController.text;
      String children = _childrenController.text;
      String prayer = _selectedPrayer ?? '---';
      String health = _healthController.text;
      String work = _workController.text;
      String companion = _companionController.text;
      String city = _cityController.text;
      String phone = _phoneController.text;
      String description = _descriptionController.text;
      String diagnosis = _diagnosisController.text;
      String treatment = _treatmentController.text;

      // Create Patient object
      Patient patient = Patient(
        serialNumberYear: serialNumberYear,
        serialNumber: serialNumber,
        fullName: fullName,
        firstName: first,
        middleName: middle,
        lastName: last,
        id: id,
        gender: gender,
        maritalStatus: maritalStatus,
        age: age,
        children: children,
        prayer: prayer,
        health: health,
        work: work,
        companion: companion,
        city: city,
        phoneNumber: phone,
        description: description,
        diagnosis: diagnosis,
        treatment: treatment,
      );
      if (widget.curPatient != null) {
        await DatabaseHelper.updatePatient(patient);
      } else {
        await DatabaseHelper.insertPatient(patient);
      }

      // Show success dialog
      _showSuccessDialog();

      // id INTEGER PRIMARY KEY AUTOINCREMENT,
      // name TEXT,
      // id_number TEXT,
      // age INTEGER,
      // gender TEXT,
      // marital_status TEXT,
      // country TEXT,
      // phone TEXT,
      // work TEXT,
      // health TEXT,
      // companion TEXT,
      // description TEXT,
      // diagnosis TEXT,
      // treatment TEXT,
      // serial_number TEXT,
      // serial_number2 TEXT,
      // children INTEGER
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
            title: Text(
              'تم الحفظ بنجاح',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'تم حفظ بيانات المريض بنجاح\n${_nameController.text}',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      _clearAllFields(); // Clear form
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'إضافة مريض جديد',
                      style: GoogleFonts.scheherazadeNew(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      widget.onButtonPressed(0); // Go back to home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'العودة للرئيسية',
                      style: GoogleFonts.scheherazadeNew(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.error, color: Colors.red, size: 50),
            title: Text(
              'خطأ في الحفظ',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'حدث خطأ أثناء حفظ البيانات:\n$error',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'موافق',
                  style: GoogleFonts.scheherazadeNew(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _clearAllFields() {
    _nameController.clear();
    _idController.clear();
    _ageController.clear();
    _cityController.clear();
    _phoneController.clear();
    _workController.clear();
    _healthController.clear();
    _companionController.clear();
    _descriptionController.clear();
    _diagnosisController.clear();
    _treatmentController.clear();
    _serialNumberController.clear();
    _serialNumberYearController.clear();
    _childrenController.clear();

    setState(() {
      _selectedGender = '---';
      _selectedPrayer = '---';
      _selectedMaritalStatus = '---';
    });
  }

  Widget _buildSerialNumberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: TextFormField(
            focusNode: _serialNumberFocusNode,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'الرقم',
              labelStyle: GoogleFonts.notoNaskhArabic(
                fontSize: 20,
                color: Colors.black,
              ),
              alignLabelWithHint: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              counterText: '',
            ),
            textAlign: TextAlign.right,
            style: GoogleFonts.notoNaskhArabic(
              color: Colors.black,
              fontSize: 20,
            ),
            controller: _serialNumberController,
            maxLength: 10,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onTapOutside: (PointerEvent event) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        const SizedBox(width: 20),
        Text('/', style: TextStyle(fontSize: 40)),
        const SizedBox(width: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: TextFormField(
            focusNode: _serialNumberYearFocusNode,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'التسلسلي',
              labelStyle: GoogleFonts.notoNaskhArabic(
                fontSize: 20,
                color: Colors.black,
              ),
              alignLabelWithHint: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              counterText: '',
            ),
            textAlign: TextAlign.right,
            style: GoogleFonts.notoNaskhArabic(
              color: Colors.black,
              fontSize: 20,
            ),
            controller: _serialNumberYearController,
            maxLength: 4,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onTapOutside: (PointerEvent event) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAgeAndGenderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: buildTextField(
            context,
            'العمر',
            3,
            TextInputType.number,
            [FilteringTextInputFormatter.digitsOnly],
            _ageFocusNode,
            1,
            TextInputAction.next,
            _ageController,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: buildDropdownField(
            'الجنس',
            ['---', 'ذكر', 'أنثى'],
            fontSize: 18,
            selectedValue: _selectedGender,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue ?? '---';
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: buildTextField(
            context,
            'أولاد',
            3,
            TextInputType.number,
            [FilteringTextInputFormatter.digitsOnly],
            _childrenFocusNode,
            1,
            TextInputAction.next,
            _childrenController,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: buildDropdownField(
            'صلاة',
            ['---', 'نعم', 'لا'],
            selectedValue: _selectedPrayer,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPrayer = newValue ?? '---';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMaritalStatusAndCountryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: buildDropdownField(
            'الحالة الإجتماعية',
            ['---', 'أعزب\\عزباء', 'متزوج\\ة', 'مطلق\\ة', 'أرمل\\ة'],
            selectedValue: _selectedMaritalStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedMaritalStatus = newValue ?? '---';
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: buildTextField(
            context,
            'البلد',
            15,
            TextInputType.text,
            null,
            _countryFocusNode,
            1,
            TextInputAction.next,
            _cityController,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneAndWorkRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: buildTextField(
            context,
            'الهاتف',
            10,
            TextInputType.number,
            [FilteringTextInputFormatter.digitsOnly],
            _phoneFocusNode,
            1,
            TextInputAction.next,
            _phoneController,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: buildTextField(
            context,
            'العمل',
            20,
            TextInputType.text,
            null,
            _workFocusNode,
            1,
            TextInputAction.next,
            _workController,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthAndCompanionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: buildTextField(
            context,
            'الصحة',
            20,
            TextInputType.text,
            null,
            _healthFocusNode,
            1,
            TextInputAction.next,
            _healthController,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: buildTextField(
            context,
            'المرافق',
            20,
            TextInputType.text,
            null,
            _companionFocusNode,
            1,
            TextInputAction.next,
            _companionController,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          widget.onButtonPressed(0);
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: <Widget>[
                    _buildSerialNumberRow(),
                    const SizedBox(height: 20),
                    buildTextField(
                      context,
                      'الإسم الثلاثي',
                      30,
                      TextInputType.name,
                      null,
                      _nameFocusNode,
                      1,
                      TextInputAction.next,
                      _nameController,
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      context,
                      'رقم الهوية',
                      9,
                      TextInputType.number,
                      [FilteringTextInputFormatter.digitsOnly],
                      _idFocusNode,
                      1,
                      TextInputAction.next,
                      _idController,
                    ),
                    const SizedBox(height: 20),
                    _buildAgeAndGenderRow(),
                    const SizedBox(height: 20),
                    _buildMaritalStatusAndCountryRow(),
                    const SizedBox(height: 20),
                    _buildPhoneAndWorkRow(),
                    SizedBox(height: 20),
                    _buildHealthAndCompanionRow(),
                    SizedBox(height: 20),
                    buildTextField(
                      context,
                      'وصف الحالة',
                      null,
                      TextInputType.multiline,
                      null,
                      _descriptionFocusNode,
                      null,
                      TextInputAction.none,
                      _descriptionController,
                    ),
                    // _buildMultilineTextField('وصف الحالة'),
                    SizedBox(height: 20),
                    buildTextField(
                      context,
                      'التشخيص',
                      null,
                      TextInputType.multiline,
                      null,
                      _diagnosisFocusNode,
                      null,
                      TextInputAction.none,
                      _diagnosisController,
                    ),

                    // _buildMultilineTextField('التشخيص'),
                    SizedBox(height: 20),
                    buildTextField(
                      context,
                      'العلاج',
                      null,
                      TextInputType.multiline,
                      null,
                      _treatmentFocusNode,
                      null,
                      TextInputAction.none,
                      _treatmentController,
                    ),
                    // _buildMultilineTextField('العلاج'),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            print('حفظ');
                            // if all fields are empty, show a message
                            if (_nameController.text.isEmpty &&
                                _serialNumberController.text.isEmpty &&
                                _serialNumberYearController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'يرجى ملء الحقول المطلوبة:\n الإسم الثلاثي، الرقم التسلسلي، سنة الرقم التسلسلي',
                                    style: GoogleFonts.scheherazadeNew(
                                      fontSize: 20,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            // Save to database
                            _addPatientToDatabase();
                            print(
                              'Patient saved: ${_nameController.text} - ${_cityController.text}',
                            );
                          },
                          icon: const Icon(Icons.save, color: Colors.green),
                          label: Text(
                            'حفظ',
                            style: GoogleFonts.scheherazadeNew(
                              fontSize: 20,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            print('تجاهل');
                          },
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            'تجاهل',
                            style: GoogleFonts.scheherazadeNew(
                              fontSize: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
