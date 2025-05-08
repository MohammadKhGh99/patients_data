import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPatientPage extends StatefulWidget {
  final Function(int) onButtonPressed;

  const AddPatientPage({super.key, required this.onButtonPressed});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
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
  final FocusNode _serialNumber2FocusNode = FocusNode();
  final FocusNode _childrenFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose FocusNodes when the widget is removed
    _nameFocusNode.dispose();
    _idFocusNode.dispose();
    _ageFocusNode.dispose();
    _genderFocusNode.dispose();
    _diagnosisFocusNode.dispose();
    _treatmentFocusNode.dispose();
    _serialNumberFocusNode.dispose();
    _serialNumber2FocusNode.dispose();
    _countryFocusNode.dispose();
    _phoneFocusNode.dispose();
    _workFocusNode.dispose();
    _healthFocusNode.dispose();
    _companionFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _childrenFocusNode.dispose();
    super.dispose();
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
            focusNode: _serialNumber2FocusNode,
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

  Widget _buildTextField(
    String labelName,
    int? maxLength,
    TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    FocusNode focusNode,
    int? maxLines,
    TextInputAction textInputAction,
  ) {
    return TextFormField(
      focusNode: focusNode,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelName,
        labelStyle: GoogleFonts.notoNaskhArabic(
          fontSize: 20,
          color: Colors.grey,
        ),
        floatingLabelStyle: GoogleFonts.notoNaskhArabic(
          fontSize: 20,
          color: Colors.black,
        ),
        alignLabelWithHint: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        counterText: '',
      ),
      textAlign: TextAlign.right,
      style: GoogleFonts.notoNaskhArabic(color: Colors.black, fontSize: 20),
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onTapOutside: (PointerEvent event) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildDropdownField(
    String labelName,
    List<String> items, {
    double fontSize = 20,
  }) {
    return DropdownButtonFormField(
      alignment: Alignment.centerRight,
      value: items[0],
      items:
          items.map((String item) {
            return DropdownMenuItem(
              value: item,
              alignment: Alignment.centerRight,
              child: Text(
                item,
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            );
          }).toList(),
      decoration: InputDecoration(
        labelText: labelName,
        labelStyle: GoogleFonts.notoNaskhArabic(
          fontSize: 20,
          color: Colors.black,
        ),
        alignLabelWithHint: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
      ),
      onChanged: (value) {
        // Handle the selected value
      },
    );
  }

  Widget _buildAgeAndGenderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: _buildTextField(
            'العمر',
            3,
            TextInputType.number,
            [FilteringTextInputFormatter.digitsOnly],
            _ageFocusNode,
            1,
            TextInputAction.next,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: _buildDropdownField('الجنس', [
            '---',
            'ذكر',
            'أنثى',
          ], fontSize: 18),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: _buildTextField(
            'أولاد',
            3,
            TextInputType.number,
            [FilteringTextInputFormatter.digitsOnly],
            _childrenFocusNode,
            1,
            TextInputAction.next,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: _buildDropdownField('صلاة', ['---', 'نعم', 'لا']),
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
          child: _buildDropdownField('الحالة الإجتماعية', [
            '---',
            'أعزب\\عزباء',
            'متزوج\\ة',
            'مطلق\\ة',
            'أرمل\\ة',
          ]),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: _buildTextField(
            'البلد',
            15,
            TextInputType.text,
            null,
            _countryFocusNode,
            1,
            TextInputAction.next,
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
          child: _buildTextField(
            'الهاتف',
            10,
            TextInputType.number,
            [FilteringTextInputFormatter.digitsOnly],
            _phoneFocusNode,
            1,
            TextInputAction.next,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: _buildTextField(
            'العمل',
            20,
            TextInputType.text,
            null,
            _workFocusNode,
            1,
            TextInputAction.next,
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
          child: _buildTextField(
            'الصحة',
            20,
            TextInputType.text,
            null,
            _healthFocusNode,
            1,
            TextInputAction.next,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.418,
          child: _buildTextField(
            'المرافق',
            20,
            TextInputType.text,
            null,
            _companionFocusNode,
            1,
            TextInputAction.next,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Expanded(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: <Widget>[
                _buildSerialNumberRow(),
                const SizedBox(height: 20),
                _buildTextField(
                  'الإسم الثلاثي',
                  30,
                  TextInputType.name,
                  null,
                  _nameFocusNode,
                  1,
                  TextInputAction.next,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'رقم الهوية',
                  9,
                  TextInputType.number,
                  [FilteringTextInputFormatter.digitsOnly],
                  _idFocusNode,
                  1,
                  TextInputAction.next,
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
                _buildTextField(
                  'وصف الحالة',
                  null,
                  TextInputType.multiline,
                  null,
                  _descriptionFocusNode,
                  null,
                  TextInputAction.none,
                ),
                // _buildMultilineTextField('وصف الحالة'),
                SizedBox(height: 20),
                _buildTextField(
                  'التشخيص',
                  null,
                  TextInputType.multiline,
                  null,
                  _diagnosisFocusNode,
                  null,
                  TextInputAction.none,
                ),

                // _buildMultilineTextField('التشخيص'),
                SizedBox(height: 20),
                _buildTextField(
                  'العلاج',
                  null,
                  TextInputType.multiline,
                  null,
                  _treatmentFocusNode,
                  null,
                  TextInputAction.none,
                ),
                // _buildMultilineTextField('العلاج'),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        print('حفظ');
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
    );
  }
}
