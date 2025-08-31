import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patients_data/add_patient.dart';
import 'package:patients_data/database_helper.dart';
import 'package:patients_data/env_config.dart';
import 'package:patients_data/search_patient.dart';
import 'package:patients_data/search_results.dart';
import 'package:patients_data/tables.dart';
import 'google_drive_service.dart';
import 'utils/logger.dart'; // ✅ Add this import
import 'constants.dart';
import 'email_service.dart';

// ✅ Update main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize logging
  AppLogger.setupLogging();

  try {
    await dotenv.load(fileName: ".env");
    AppLogger.success('.env file loaded successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Error loading .env file', e, stackTrace);
  }

  // Initialize Google Drive Service
  await GoogleDriveService.initialize();

  runApp(const MyApp());
  // GoogleDriveService.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'علاج',
      locale: const Locale('ar'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(
        title: Text(
          backupFolderName,
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Traditional Arabic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final Text title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var indexesArray = [0];
  var backButtonPressed = false;
  List<Patient?>? foundPatients = [];
  Patient? curPatient;

  void _onButtonPressed(
    int index, {
    List<Patient?>? patients,
    Patient? selectedPatient,
  }) async {
    // Handle system back button
    if (index == -1) {
      // Use same logic as AppBar back button
      setState(() {
        backButtonPressed = true;
        if (indexesArray.length <= 1) {
          selectedIndex = 0;
          return;
        }
        indexesArray.removeLast();
        selectedIndex = indexesArray.isNotEmpty ? indexesArray.last : 0;
      });
      return; // Don't show loading for back navigation
    }

    // Show loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    loadingText,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );

    // Simulate loading time (you can add actual data loading here)
    await Future.delayed(Duration(milliseconds: 500));

    // Close loading dialog
    if (mounted) Navigator.of(context).pop();

    // Update state
    setState(() {
      selectedIndex = index;
      if (patients != null) {
        foundPatients = patients;
      }
      if (selectedPatient != null) {
        curPatient = selectedPatient;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page = MainMenuPage(
      onButtonPressed: (int index) => _onButtonPressed(index),
    );

    if (selectedIndex == 0) {
      indexesArray.clear();
      indexesArray.add(0);
      curPatient = null;
    }
    if (!backButtonPressed) {
      if (indexesArray.isNotEmpty && indexesArray.last != selectedIndex) {
        indexesArray.add(selectedIndex);
      }
    } else {
      backButtonPressed = false;
      // print('selectedIndex: $selectedIndex');
    }
    // print('indexesArray: $indexesArray');

    switch (selectedIndex) {
      case 0:
        page = MainMenuPage(
          onButtonPressed: (int index) => _onButtonPressed(index),
        );
      case 1:
        page = AddPatientPage(
          onButtonPressed: (int index) => _onButtonPressed(index),
          curPatient: curPatient,
        );
      case 2:
        page = SearchPatientPage(onButtonPressed: _onButtonPressed);
      case 3:
        page = SearchResultsPage(
          onButtonPressed: _onButtonPressed,
          patients: foundPatients ?? [],
        );
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Padding(
          padding: EdgeInsets.only(
            // right: MediaQuery.of(context).size.width * 0.1,
            left: MediaQuery.of(context).size.width * 0.11,
          ),
          child: widget.title,
        ),
        leading: IconButton(
          onPressed: () {
            // print('Back button pressed');
            backButtonPressed = true;
            setState(() {
              if (indexesArray.length <= 1) {
                selectedIndex = 0;
                return;
              }
              indexesArray.removeLast();
              selectedIndex = indexesArray.isNotEmpty ? indexesArray.last : 0;
            });
          },
          icon: Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    const Text(
                      bismillahText,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Traditional Arabic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      patientCardTitle,
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Traditional Arabic',
                      ),
                    ),
                    const SizedBox(height: 50),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        // ✅ Use FadeTransition instead of SlideTransition to avoid layout issues
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Container(
                        key: ValueKey<int>(selectedIndex),
                        child: PopScope(
                          canPop: false, // ✅ Add canPop: false
                          onPopInvokedWithResult: (didPop, result) {
                            if (!didPop) {
                              _onButtonPressed(-1);
                            }
                          },
                          child: page,
                        ),
                      ),
                    ),
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

class MainMenuPage extends StatefulWidget {
  final Function(int) onButtonPressed;

  const MainMenuPage({super.key, required this.onButtonPressed});

  @override
  State<MainMenuPage> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenuPage> {
  bool _isSignedIn = false;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _sendDatabaseByEmail(String? email) async {
    // make a text field to make the user enter his email to send the backup to it

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        emailBackup,
                        style: GoogleFonts.scheherazadeNew(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );

      final success = await EmailService.sendDatabaseBackup(customRecipient: email);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show result
      if (mounted) {  
        showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              icon: Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                    size: 50,
              ),
              title: Text(
                success ? sendingSuccess : sendingFailure,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                success ? emailBackupSuccess : emailBackupFailure,
                style: GoogleFonts.scheherazadeNew(fontSize: 16),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    acceptText,
                    style: GoogleFonts.scheherazadeNew(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      // print('Email error: $e');
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _checkSignInStatus() async {
    final isSignedIn = await GoogleDriveService.isSignedIn();
    final userEmail = await GoogleDriveService.getCurrentUserEmail();

    setState(() {
      _isSignedIn = isSignedIn;
      _userEmail = userEmail;
    });
  }

  Future<void> _uploadToGoogleDrive() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      googleDriveLoadingBackup,
                      style: GoogleFonts.scheherazadeNew(fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
      );

      final success = await GoogleDriveService.uploadDatabase();

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show result
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  icon: Icon(
                    success ? Icons.check_circle : Icons.error,
                    color: success ? Colors.green : Colors.red,
                    size: 50,
                  ),
                  title: Text(
                    success ? uploadedSuccessfully : uploadedFailure,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    success ? uploadedSuccessfully : uploadedFailure,
                    style: GoogleFonts.scheherazadeNew(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        acceptText,
                        style: GoogleFonts.scheherazadeNew(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _downloadFromGoogleDrive() async {
    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                icon: Icon(Icons.warning, color: Colors.orange, size: 50),
                title: Text(
                  confirmRecovery,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  checkUserRecovery,
                  style: GoogleFonts.scheherazadeNew(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      declineText,
                      style: GoogleFonts.scheherazadeNew(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      acceptRecovery,
                      style: GoogleFonts.scheherazadeNew(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      );

      if (confirmed != true) return;

      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text(
                        googleDriveLoadingRecovery,
                        style: GoogleFonts.scheherazadeNew(fontSize: 12),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
        );
      }

      final success = await GoogleDriveService.downloadDatabase();

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show result
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  icon: Icon(
                    success ? Icons.check_circle : Icons.error,
                    color: success ? Colors.green : Colors.red,
                    size: 50,
                  ),
                  title: Text(
                    success ? recoverySuccess : recoveryFailure,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    success
                        ? googleDriveRecoverySuccess
                        : googleDriveRecoveryFailure,
                    style: GoogleFonts.scheherazadeNew(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        acceptText,
                        style: GoogleFonts.scheherazadeNew(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
        );
      }
    } catch (e) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _convertDatabaseToCSV() async {
    // show dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text(
                      csvLoadingConversion,
                      style: GoogleFonts.scheherazadeNew(fontSize: 12),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
      );
    }

    final csvData = await DatabaseHelper.generateCSVFromDatabase();
    bool success = csvData.isNotEmpty;

    // Close loading dialog
    if (mounted) Navigator.of(context).pop();

    // Show result
    if (mounted) {
      showDialog(
        context: context,
        builder:
            (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                icon: Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: success ? Colors.green : Colors.red,
                  size: 50,
                ),
                title: Text(
                  success ? csvConversionSuccess : csvConversionFailure,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  success ? csvConversionSuccess : csvConversionFailure,
                  style: GoogleFonts.scheherazadeNew(fontSize: 16),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      acceptText,
                      style: GoogleFonts.scheherazadeNew(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
      );
    }

    // print('CSV Data: $csvData');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Show Google account status
        if (_isSignedIn && _userEmail != null) ...[
          Container(
            padding: EdgeInsets.all(10),
            // margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_circle, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'متصل: $_userEmail',
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 50),
        ElevatedButton.icon(
          onPressed: () {
            // print('إضافة مريض جديد');
            widget.onButtonPressed(1);
          },
          icon: const Icon(Icons.add, color: Colors.black),
          label: Text(
            addNewPatient,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // print('ابحث عن مريض');
            widget.onButtonPressed(2);
          },
          icon: const Icon(Icons.search, color: Colors.black),
          label: Text(
            'ابحث عن مريض',
            style: GoogleFonts.scheherazadeNew(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _uploadToGoogleDrive,
          icon: const FaIcon(FontAwesomeIcons.googleDrive, color: Colors.green),
          label: Text(
            saveToGoogleDrive,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _downloadFromGoogleDrive,
          icon: const FaIcon(FontAwesomeIcons.googleDrive, color: Colors.green),
          label: Text(
            recoverFromGoogleDrive,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _convertDatabaseToCSV,
          icon: const FaIcon(FontAwesomeIcons.fileExcel, color: Colors.green),
          label: Text(
            convertToExcel,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            String? email;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'أدخل بريدك الإلكتروني',
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(hintText: 'ايميل'),
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _sendDatabaseByEmail(email);
                      },
                      child: Text('إرسال'),
                    ),
                  ],
                );
              },
            );

            // _sendDatabaseByEmail(email);
          },
          icon: const FaIcon(FontAwesomeIcons.envelope, color: Colors.blue),
          label: Text(
            sendToEmail,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        ),
        // Add this to your build method in _MainMenuState:
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            final success = await GoogleDriveService.signInToGoogle();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? loginSuccess : loginFailed),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
            _checkSignInStatus();
          },
          icon: const FaIcon(
            FontAwesomeIcons.google,
            color: Colors.purple,
          ), // ✅ Google icon
          label: Text(
            googleLogin,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 16,
              color: Colors.purple,
            ),
          ),
        ),
        // Add this button temporarily for debugging
        // ElevatedButton.icon(
        //   onPressed: () async {
        //     // Check environment configuration
        //     // print('=== DEBUG INFO ===');
        //     // print('Client ID from env: ${EnvConfig.googleOAuthClientId}');
        //     // print('Has Google Credentials: ${EnvConfig.hasGoogleCredentials}');
        //     // print('Client ID length: ${EnvConfig.googleOAuthClientId.length}');
        //     // print('Client ID starts with: ${EnvConfig.googleOAuthClientId.substring(0, 20)}...');

        //     // Check package name
        //     // print('Expected package: com.example.patients_data');

        //     // Show dialog with info
        //     showDialog(
        //       context: context,
        //       builder:
        //           (context) => AlertDialog(
        //             content: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   'Has Client ID: ${EnvConfig.hasGoogleCredentials}',
        //                 ),
        //                 Text(
        //                   'Client ID Length: ${EnvConfig.googleOAuthClientId.length}',
        //                 ),
        //                 if (EnvConfig.hasGoogleCredentials)
        //                   Text(
        //                     'Client ID: ${EnvConfig.googleOAuthClientId.substring(0, 20)}...',
        //                   ),
        //               ],
        //             ),
        //             actions: [
        //               TextButton(
        //                 onPressed: () => Navigator.pop(context),
        //                 child: Text('OK'),
        //               ),
        //             ],
        //           ),
        //     );
        //   },
        //   icon: Icon(Icons.bug_report),
        //   label: Text('Debug Config'),
        // ),
      ],
    );
  }
}
