import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helpers.dart';

class SearchPatientPage extends StatefulWidget {
  // final Function(int) onButtonPressed;

  const SearchPatientPage({super.key});

  @override
  State<SearchPatientPage> createState() => _SearchPatientPageState();
}

class _SearchPatientPageState extends State<SearchPatientPage> {
  String? _selectedSearchMethod;
  
  // Define a controller for the search TextField
  // This controller can be used to retrieve the text input by the user
  final TextEditingController _searchController = TextEditingController();


  // FocusNode to manage the focus state of the search TextField
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose the TextEditingController when the widget is removed
    _searchController.dispose();
    // Dispose FocusNodes when the widget is removed
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Widget _buildTextField(
  //   String labelName,
  //   int? maxLength,
  //   TextInputType keyboardType,
  //   List<TextInputFormatter>? inputFormatters,
  //   FocusNode focusNode,
  //   int? maxLines,
  //   TextInputAction textInputAction,
  // ) {
  //   return TextFormField(
  //     focusNode: focusNode,
  //     textInputAction: textInputAction,
  //     decoration: InputDecoration(
  //       labelText: labelName,
  //       labelStyle: GoogleFonts.notoNaskhArabic(
  //         fontSize: 20,
  //         color: Colors.grey,
  //       ),
  //       floatingLabelStyle: GoogleFonts.notoNaskhArabic(
  //         fontSize: 20,
  //         color: Colors.black,
  //       ),
  //       alignLabelWithHint: true,
  //       border: const OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //         borderSide: BorderSide(color: Colors.black, width: 2),
  //       ),
  //       counterText: '',
  //     ),
  //     textAlign: TextAlign.right,
  //     style: GoogleFonts.notoNaskhArabic(color: Colors.black, fontSize: 20),
  //     maxLength: maxLength,
  //     maxLines: maxLines,
  //     keyboardType: keyboardType,
  //     inputFormatters: inputFormatters,
  //     onTapOutside: (PointerEvent event) {
  //       FocusScope.of(context).unfocus();
  //     },
  //   );
  // }

  // Widget _buildDropdownField(
  //   String labelName,
  //   List<String> items, {
  //   double fontSize = 20,
  // }) {
  //   return DropdownButtonFormField(
  //     alignment: Alignment.centerRight,
  //     value: items[0],
  //     items:
  //         items.map((String item) {
  //           return DropdownMenuItem(
  //             value: item,
  //             alignment: Alignment.centerRight,
  //             child: Text(
  //               item,
  //               style: GoogleFonts.notoNaskhArabic(
  //                 fontSize: fontSize,
  //                 color: Colors.black,
  //               ),
  //               textAlign: TextAlign.right,
  //               textDirection: TextDirection.rtl,
  //             ),
  //           );
  //         }).toList(),
  //     decoration: InputDecoration(
  //       labelText: labelName,
  //       labelStyle: GoogleFonts.notoNaskhArabic(
  //         fontSize: 20,
  //         color: Colors.black,
  //       ),
  //       alignLabelWithHint: true,
  //       border: const OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //         borderSide: BorderSide(color: Colors.black, width: 2),
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(
  //         vertical: 20,
  //         horizontal: 10,
  //       ),
  //     ),
  //     onChanged: (value) {
  //       // Handle the selected value
  //     },
  //   );
  // }

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
                buildDropdownField('طريقة البحث', [
                  'الإسم الشخصي',
                  'الإسم الشخصي واسم الأب',
                  'الإسم الشخصي واسم العائلة',
                  'اسم العائلة',
                  'الإسم الثلاثي',
                  'رقم الهوية',
                  ], 
                  fontSize: 16,
                  selectedValue: _selectedSearchMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedSearchMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                buildTextField(
                  context,
                  'البحث عن',
                  30,
                  TextInputType.text,
                  null,
                  _searchFocusNode,
                  1,
                  TextInputAction.done,
                  _searchController,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    print('البحث عن مريض');
                    

                  },
                  icon: const Icon(Icons.search, color: Colors.black),
                  label: Text(
                    'البحث',
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
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
