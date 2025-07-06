import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patients_data/tables.dart';
import 'helpers.dart';

class SearchResultsPage extends StatefulWidget {
  final Function(int, {List<Patient?>? patients, Patient? selectedPatient}) onButtonPressed;
  final List<Patient?> patients;

  const SearchResultsPage({
    super.key,
    required this.onButtonPressed,
    required this.patients,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  String selectedResult = '';

  late Map<String, Patient> searchResults;

  // FocusNode to manage the focus state of the search TextField
  final FocusNode _searchResultsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Check if results are empty and show warning
    if (widget.patients.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoResultsAndGoBack();
      });
    }

    // Build search results map
    searchResults = {};
    for (var patient in widget.patients) {
      if (patient != null) {
        searchResults["${patient.serialNumberYear}: ${patient.fullName} - ${patient.city}"] =
            patient;
      }
    }
    selectedResult = searchResults.isNotEmpty ? searchResults.keys.first : '';
  }

  void _showNoResultsAndGoBack() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.search_off, color: Colors.orange, size: 50),
            title: Text(
              'لا توجد نتائج',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'لم يتم العثور على أي مريض يطابق معايير البحث',
              style: GoogleFonts.scheherazadeNew(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onButtonPressed(2); // Go back to search
                },
                child: Text(
                  'العودة للبحث',
                  style: GoogleFonts.scheherazadeNew(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose FocusNodes when the widget is removed
    _searchResultsFocusNode.dispose();
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
                  _buildResultsContent(),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      print('تم');
                      widget.onButtonPressed(1, selectedPatient: searchResults[selectedResult]);
                    },
                    icon: const Icon(Icons.search, color: Colors.black),
                    label: Text(
                      'تم',
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

  Widget _buildResultsContent() {
    return buildDropdownField(
      "نتائج البحث:",
      searchResults.keys.toList(),
      fontSize: 16,
      selectedValue: searchResults.isNotEmpty ? searchResults.keys.first : '',
      onChanged: (String? value) {
        setState(() {
          selectedResult = value ?? '';
        });
      },
    );
  }
}
