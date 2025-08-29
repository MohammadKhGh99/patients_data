import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// Use alias to avoid conflict
import 'tables.dart';
import 'database_helper.dart';
import 'helpers.dart';
import 'constants.dart';

class AddPatientPage extends StatefulWidget {
  final Function(int) onButtonPressed;
  final Patient? curPatient;

  const AddPatientPage({
    super.key,
    required this.onButtonPressed,
    this.curPatient,
  });

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  String? _selectedGender = emptySelection;
  String? _selectedPrayer = emptySelection;
  String? _selectedMaritalStatus = emptySelection;

  // Add TextEditingControllers for each field
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
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
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
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
    print(
      'Initializing AddPatientPage with current patient: ${widget.curPatient}',
    );
    if (widget.curPatient != null) {
      final patient = widget.curPatient!;

      _firstNameController.text = patient.firstName ?? empty;
      _middleNameController.text = patient.middleName ?? empty;
      _lastNameController.text = patient.lastName ?? empty;
      _idController.text = patient.id ?? empty;
      _ageController.text = patient.age ?? empty;
      _cityController.text = patient.city ?? empty;
      _phoneController.text = patient.phoneNumber ?? empty;
      _workController.text = patient.work ?? empty;
      _healthController.text = patient.health ?? empty;
      _companionController.text = patient.companion ?? empty;
      _descriptionController.text = patient.description ?? empty;
      _diagnosisController.text = patient.diagnosis ?? empty;
      _treatmentController.text = patient.treatment ?? empty;
      _serialNumberController.text = patient.serialNumber ?? empty;
      _serialNumberYearController.text = patient.serialNumberYear ?? empty;
      _childrenController.text = patient.children ?? empty;

      // Set dropdown values based on current patient data
      setState(() {
        _selectedGender = patient.gender ?? emptySelection;
        _selectedPrayer = patient.prayer ?? emptySelection;
        _selectedMaritalStatus = patient.maritalStatus ?? emptySelection;
      });
    } else {
      _initializeSerialNumbers();
    }
  }

  // ✅ Initialize serial numbers properly
  Future<void> _initializeSerialNumbers() async {
    // For new patient, get the next available serial number
    try {
      int nextSerial = await DatabaseHelper.getNextSerialNumber();
      setState(() {
        _serialNumberController.text = nextSerial.toString();
        _serialNumberYearController.text = DateTime.now().year.toString();
      });
      print('Next serial number will be: $nextSerial');
    } catch (e) {
      print('Error getting next serial number: $e');
      // Fallback
      setState(() {
        _serialNumberController.text = '2';
        _serialNumberYearController.text = DateTime.now().year.toString();
      });
    }
  }

  @override
  void dispose() {
    // Dispose TextEditingControllers when the widget is removed
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
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
    _firstNameFocusNode.dispose();
    _middleNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
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
      String firstName = _firstNameController.text;
      String middleName = _middleNameController.text;
      String lastName = _lastNameController.text;
      String fullName = '$firstName $middleName $lastName';

      // List<String> nameParts = fullName.split(' ');
      // String first = nameParts.isNotEmpty ? nameParts[0] : empty;
      // String middle = nameParts.length > 2 ? nameParts[1] : empty;
      // String last = nameParts.length > 1 ? nameParts[2] : empty;

      // If there are more than 3 parts, join the rest as last name
      // if (nameParts.length > 3) {
      //   last = nameParts.sublist(3).join(' ');
      // }

      String id = _idController.text;
      String gender = _selectedGender ?? emptySelection;
      String maritalStatus = _selectedMaritalStatus ?? emptySelection;
      String age = _ageController.text;
      String children = _childrenController.text;
      String prayer = _selectedPrayer ?? emptySelection;
      String health = _healthController.text;
      String work = _workController.text;
      String companion = _companionController.text;
      String city = _cityController.text;
      String phone = _phoneController.text;
      String description = _descriptionController.text;
      String diagnosis = _diagnosisController.text;
      String treatment = _treatmentController.text;

      // Create Patient object
      Patient? patient = Patient(
        serialNumberYear: serialNumberYear,
        serialNumber: serialNumber,
        fullName: fullName,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
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
        // Update existing patient only if there is at least one change
        if (widget.curPatient == patient) {
          await DatabaseHelper.updatePatient(patient);
        }
      } else {
        await DatabaseHelper.insertPatient(patient);
      }

      // Show success dialog
      _showSuccessDialog();
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
              saveSuccess,
              style: GoogleFonts.scheherazadeNew(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'تم حفظ بيانات المريض بنجاح\n${_firstNameController.text} ${_middleNameController.text} ${_lastNameController.text}',
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
                      addNewPatient,
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
                      backToMainMenu,
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
              saveFailed,
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
                  acceptText,
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
    _firstNameController.clear();
    _middleNameController.clear();
    _lastNameController.clear();
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
      _selectedGender = emptySelection;
      _selectedPrayer = emptySelection;
      _selectedMaritalStatus = emptySelection;
    });
  }

  Widget _buildSerialNumberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: TextFormField(
            enabled: false,
            focusNode: _serialNumberFocusNode,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: serialNumber,
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
              counterText: empty,
            ),
            textAlign: TextAlign.right,
            style: GoogleFonts.notoNaskhArabic(
              color: Colors.black,
              fontSize: 20,
            ),
            controller: _serialNumberController,
            readOnly:
                widget.curPatient !=
                null, // Make it read-only if editing an existing patient
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
            enabled: false,
            focusNode: _serialNumberYearFocusNode,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: yearText,
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
              counterText: empty,
            ),
            textAlign: TextAlign.right,
            style: GoogleFonts.notoNaskhArabic(
              color: Colors.black,
              fontSize: 20,
            ),
            controller: _serialNumberYearController,
            readOnly:
                widget.curPatient !=
                null, // Make it read-only if editing an existing patient
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
            ageText,
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
            genderText,
            [emptySelection, maleText, femaleText],
            fontSize: 18,
            selectedValue: _selectedGender,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue ?? emptySelection;
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: buildTextField(
            context,
            childrenText,
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
            [emptySelection, 'نعم', 'لا'],
            selectedValue: _selectedPrayer,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPrayer = newValue ?? emptySelection;
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
            maritalStatusText,
            [emptySelection, 'أعزب\\عزباء', 'متزوج\\ة', 'مطلق\\ة', 'أرمل\\ة'],
            selectedValue: _selectedMaritalStatus,
            onChanged: (String? newValue) {
              setState(() {
                _selectedMaritalStatus = newValue ?? emptySelection;
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: buildTextField(
            context,
            cityText,
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
            phoneNumberText,
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
            workText,
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
            healthText,
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
            companionText,
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

  Widget _buildMultilineField(
    String text,
    FocusNode focusNode,
    TextEditingController controller,
  ) {
    return buildTextField(
      context,
      text,
      null,
      TextInputType.multiline,
      null,
      focusNode,
      null,
      TextInputAction.none,
      controller,
    );
  }

  Widget _buildFirstMiddleNameFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: buildTextField(
            context,
            firstNameText,
            15,
            TextInputType.name,
            null,
            _firstNameFocusNode,
            1,
            TextInputAction.next,
            _firstNameController,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: buildTextField(
            context,
            middleNameText,
            15,
            TextInputType.name,
            null,
            _middleNameFocusNode,
            1,
            TextInputAction.next,
            _middleNameController,
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameIDFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: buildTextField(
            context,
            lastNameText,
            15,
            TextInputType.name,
            null,
            _lastNameFocusNode,
            1,
            TextInputAction.next,
            _lastNameController,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: buildTextField(
            context,
            idNumberText,
            9,
            TextInputType.number,
            [FilteringTextInputFormatter.digitsOnly],
            _idFocusNode,
            1,
            TextInputAction.next,
            _idController,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            print('حفظ');
            // if all fields are empty, show a message
            if (_firstNameController.text.isEmpty &&
                _middleNameController.text.isEmpty &&
                _lastNameController.text.isEmpty &&
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
              'Patient saved: ${_firstNameController.text} ${_middleNameController.text} ${_lastNameController.text} - ${_cityController.text}',
            );
          },
          icon: const Icon(Icons.save, color: Colors.green),
          label: Text(
            saveText,
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
            discardText,
            style: GoogleFonts.scheherazadeNew(fontSize: 20, color: Colors.red),
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
          // widget.onButtonPressed(0);
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
                    _buildFirstMiddleNameFields(),
                    const SizedBox(height: 20),
                    _buildLastNameIDFields(),
                    const SizedBox(height: 20),
                    _buildAgeAndGenderRow(),
                    const SizedBox(height: 20),
                    _buildMaritalStatusAndCountryRow(),
                    const SizedBox(height: 20),
                    _buildPhoneAndWorkRow(),
                    SizedBox(height: 20),
                    _buildHealthAndCompanionRow(),
                    SizedBox(height: 20),
                    _buildMultilineField(
                      descriptionText,
                      _descriptionFocusNode,
                      _descriptionController,
                    ),
                    SizedBox(height: 20),
                    _buildMultilineField(
                      diagnosisText,
                      _diagnosisFocusNode,
                      _diagnosisController,
                    ),
                    SizedBox(height: 20),
                    _buildMultilineField(
                      treatmentText,
                      _treatmentFocusNode,
                      _treatmentController,
                    ),
                    SizedBox(height: 30),
                    _buildButtonsRow(),
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
