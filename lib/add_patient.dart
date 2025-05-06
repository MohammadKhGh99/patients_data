import 'package:flutter/material.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'اسم المريض',
                hintText: 'أدخل اسم المريض',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
