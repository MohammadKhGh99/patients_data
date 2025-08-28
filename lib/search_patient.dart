import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patients_data/database_helper.dart';
import 'package:patients_data/tables.dart';
import 'helpers.dart';

class SearchPatientPage extends StatefulWidget {
  final Function(int, {List<Patient?>? patients, Patient? selectedPatient})
  onButtonPressed;

  const SearchPatientPage({super.key, required this.onButtonPressed});

  @override
  State<SearchPatientPage> createState() => _SearchPatientPageState();
}

class _SearchPatientPageState extends State<SearchPatientPage> {
  String _selectedSearchMethod = 'الإسم الشخصي';

  // Define a controller for the search TextField
  // This controller can be used to retrieve the text input by the user
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _search1Controller = TextEditingController();

  // FocusNode to manage the focus state of the search TextField
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _search1FocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose the TextEditingController when the widget is removed
    _searchController.dispose();
    _search1Controller.dispose();
    // Dispose FocusNodes when the widget is removed
    _searchFocusNode.dispose();
    _search1FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Use the same logic as your AppBar back button
          // widget.onButtonPressed(0); // Special index for "go back"
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: <Widget>[
                  const Text('البحث عن:'),
                  buildTextField(
                    context,
                    _selectedSearchMethod.split(' و')[0],
                    15,
                    TextInputType.text,
                    null,
                    _searchFocusNode,
                    1,
                    _selectedSearchMethod == 'الإسم الشخصي واسم الأب' ||
                            _selectedSearchMethod == 'الإسم الشخصي واسم العائلة'
                        ? TextInputAction.next
                        : TextInputAction.done,
                    _searchController,
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: _selectedSearchMethod == 'الإسم الشخصي واسم الأب',
                    child: buildTextField(
                      context,
                      'اسم الأب',
                      15,
                      TextInputType.text,
                      null,
                      _search1FocusNode,
                      1,
                      TextInputAction.done,
                      _search1Controller,
                    ),
                  ),
                  Visibility(
                    visible:
                        _selectedSearchMethod == 'الإسم الشخصي واسم العائلة',
                    child: buildTextField(
                      context,
                      'اسم العائلة',
                      15,
                      TextInputType.text,
                      null,
                      _search1FocusNode,
                      1,
                      TextInputAction.done,
                      _search1Controller,
                    ),
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

                      List<Patient?>? searchResults;

                      if (_selectedSearchMethod == 'الإسم الشخصي واسم الأب' ||
                          _selectedSearchMethod ==
                              'الإسم الشخصي واسم العائلة') {
                        searchResults = await DatabaseHelper.getPatients(
                          _selectedSearchMethod,
                          _searchController.text,
                          _search1Controller.text,
                        );
                      } else {
                        searchResults = await DatabaseHelper.getPatients(
                          _selectedSearchMethod,
                          _searchController.text,
                          null,
                        );
                      }

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
