import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patients_data/database_helper.dart';
import 'package:patients_data/tables.dart';
import 'helpers.dart';

class SearchPatientPage extends StatefulWidget {
  final Function(int, {List<Patient?>? patients, Patient? selectedPatient}) onButtonPressed;

  const SearchPatientPage({super.key, required this.onButtonPressed});

  @override
  State<SearchPatientPage> createState() => _SearchPatientPageState();
}

class _SearchPatientPageState extends State<SearchPatientPage> {
  String _selectedSearchMethod = 'الإسم الشخصي';

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
        child: Expanded(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: <Widget>[
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
                  buildDropdownField(
                    'طريقة البحث',
                    [
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
                        _selectedSearchMethod = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      print('البحث عن مريض');

                      List<Patient?>? searchResults =
                          await DatabaseHelper.getPatients(
                            _selectedSearchMethod,
                            _searchController.text,
                          );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SearchResultsPage(
                      //       onButtonPressed: widget.onButtonPressed,
                      //       patients: searchResults ?? [],
                      //     ),
                      //   ),
                      // );

                      print(searchResults);
                      widget.onButtonPressed(3, patients: searchResults);
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
      ),
    );
  }
}
