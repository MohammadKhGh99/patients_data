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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'اسم المريض',
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
                  style: GoogleFonts.notoNaskhArabic(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  maxLength: 30,
                  onTapOutside: (PointerEvent event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'رقم الهوية',
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
                  style: GoogleFonts.notoNaskhArabic(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  maxLength: 9,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onTapOutside: (PointerEvent event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'العمر',
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
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          counterText: '',
                        ),
                        textAlign: TextAlign.right,
                        style: GoogleFonts.notoNaskhArabic(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        maxLength: 3,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: DropdownButtonFormField(
                        alignment: Alignment.centerRight,
                        value: '---',
                        items: [
                          DropdownMenuItem(
                            value: '---',
                            alignment: Alignment.centerRight,
                            child: Text(
                              '---',
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'ذكر',
                            alignment: Alignment.centerRight,
                            child: Text(
                              'ذكر',
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'أنثى',
                            alignment: Alignment.centerRight,
                            child: Text(
                              'أنثى',
                              style: GoogleFonts.notoNaskhArabic(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'الجنس',
                          labelStyle: GoogleFonts.notoNaskhArabic(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          alignLabelWithHint: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical:
                                20, // Adjust this value to increase height
                            horizontal: 10,
                          ),
                        ),
                        onChanged: (value) {
                          // Handle the selected value
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'أولاد',
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
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          counterText: '',
                        ),
                        textAlign: TextAlign.right,
                        style: GoogleFonts.notoNaskhArabic(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        maxLength: 3,
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
                ),
                const SizedBox(height: 20),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //   labelText: 'رقم الجوال',
                //   labelStyle: GoogleFonts.notoNaskhArabic(
                //     fontSize: 20,
                //     color: Colors.black,
                //   ),
                //   alignLabelWithHint: true,
                //   border: const OutlineInputBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //     borderSide: BorderSide(color: Colors.black, width: 2),
                //   ),
                //   counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //   color: Colors.black,
                //   fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //   FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //   labelText: 'رقم الجوال',
                //   labelStyle: GoogleFonts.notoNaskhArabic(
                //     fontSize: 20,
                //     color: Colors.black,
                //   ),
                //   alignLabelWithHint: true,
                //   border: const OutlineInputBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //     borderSide: BorderSide(color: Colors.black, width: 2),
                //   ),
                //   counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //   color: Colors.black,
                //   fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //   FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //   labelText: 'رقم الجوال',
                //   labelStyle: GoogleFonts.notoNaskhArabic(
                //     fontSize: 20,
                //     color: Colors.black,
                //   ),
                //   alignLabelWithHint: true,
                //   border: const OutlineInputBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //     borderSide: BorderSide(color: Colors.black, width: 2),
                //   ),
                //   counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //   color: Colors.black,
                //   fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //   FocusScope.of(context).unfocus();
                //   },
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'رقم الجوال',
                //     labelStyle: GoogleFonts.notoNaskhArabic(
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //     alignLabelWithHint: true,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       borderSide: BorderSide(color: Colors.black, width: 2),
                //     ),
                //     counterText: '',
                //   ),
                //   textAlign: TextAlign.right,
                //   style: GoogleFonts.notoNaskhArabic(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   maxLength: 10,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly,
                //   ],
                //   onTapOutside: (PointerEvent event) {
                //     FocusScope.of(context).unfocus();
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
