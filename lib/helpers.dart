import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


Widget buildTextField(
  BuildContext context,
  String labelName,
  int? maxLength,
  TextInputType keyboardType,
  List<TextInputFormatter>? inputFormatters,
  FocusNode focusNode,
  int? maxLines,
  TextInputAction textInputAction,
  TextEditingController? controller,
) {
  return TextFormField(
    focusNode: focusNode,
    textInputAction: textInputAction,
    decoration: InputDecoration(
      labelText: labelName,
      labelStyle: GoogleFonts.notoNaskhArabic(fontSize: 20, color: Colors.grey),
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
    controller: controller,
    maxLength: maxLength,
    maxLines: maxLines,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    onTapOutside: (PointerEvent event) {
      FocusScope.of(context).unfocus();
    },
  );
}


Widget buildDropdownField(
  String labelName,
  List<String> items, {
  double fontSize = 20,
  String? selectedValue,
  ValueChanged<String?>? onChanged,
  }) {
  return DropdownButtonFormField(
    alignment: Alignment.centerRight,
    value: selectedValue ?? items[0],
    items: items.map((String item) {
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
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    ),
    onChanged: onChanged,
  );
}
