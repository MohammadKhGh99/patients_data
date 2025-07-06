import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patients_data/add_patient.dart';
import 'package:patients_data/search_patient.dart';
import 'package:patients_data/search_results.dart';
import 'package:patients_data/tables.dart';
import 'google_drive_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'email_service.dart';
import 'env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
  GoogleDriveService.initialize();
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
          'المعالجة بالرقية الشرعية',
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
  }) {
    setState(() {
      selectedIndex = index;
      if (patients != null) {
        foundPatients = patients; // Store the found patients
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

    if (!backButtonPressed) {
      if (indexesArray.isNotEmpty && indexesArray.last != selectedIndex) {
        indexesArray.add(selectedIndex);
      }
    } else {
      backButtonPressed = false;
      print('selectedIndex: $selectedIndex');
    }
    print('indexesArray: $indexesArray');

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
            print('Back button pressed');
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
                      'بِسْمِ اللهِ الرَّحْمنِ الرَّحِيم',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Traditional Arabic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'بطاقة علاج',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Traditional Arabic',
                      ),
                    ),
                    const SizedBox(height: 50),
                    page,
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

  Future<void> _sendDatabaseByEmail() async {
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
                        'جاري إرسال النسخة الاحتياطية بالإيميل...',
                        style: GoogleFonts.scheherazadeNew(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );

      final success = await EmailService.sendDatabaseBackup();

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
                    success ? 'تم الإرسال بنجاح' : 'فشل في الإرسال',
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    success
                        ? 'تم إرسال النسخة الاحتياطية بالإيميل بنجاح'
                        : 'حدث خطأ أثناء إرسال الإيميل. تأكد من إعدادات الإيميل في ملف .env',
                    style: GoogleFonts.scheherazadeNew(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'موافق',
                        style: GoogleFonts.scheherazadeNew(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
        );
      }
    } catch (e) {
      print('Email error: $e');
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
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text(
                      'جاري الرفع إلى جوجل درايف...',
                      style: GoogleFonts.scheherazadeNew(fontSize: 16),
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
                    success ? 'تم الرفع بنجاح' : 'فشل في الرفع',
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    success
                        ? 'تم رفع قاعدة البيانات إلى جوجل درايف بنجاح'
                        : 'حدث خطأ أثناء رفع قاعدة البيانات',
                    style: GoogleFonts.scheherazadeNew(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'موافق',
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
                  'تأكيد الاستعادة',
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  'سيتم استبدال قاعدة البيانات الحالية بالنسخة الاحتياطية من جوجل درايف. هل أنت متأكد؟',
                  style: GoogleFonts.scheherazadeNew(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'إلغاء',
                      style: GoogleFonts.scheherazadeNew(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      'نعم، استعادة',
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
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text(
                        'جاري الاستعادة من جوجل درايف...',
                        style: GoogleFonts.scheherazadeNew(fontSize: 16),
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
                    success ? 'تمت الاستعادة بنجاح' : 'فشل في الاستعادة',
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    success
                        ? 'تم استعادة قاعدة البيانات من جوجل درايف بنجاح'
                        : 'حدث خطأ أثناء استعادة قاعدة البيانات',
                    style: GoogleFonts.scheherazadeNew(fontSize: 16),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'موافق',
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Show Google account status
          if (_isSignedIn && _userEmail != null) ...[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20),
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

          const SizedBox(height: 80),
          ElevatedButton.icon(
            onPressed: () {
              print('إضافة مريض جديد');
              widget.onButtonPressed(1);
            },
            icon: const Icon(Icons.add, color: Colors.black),
            label: Text(
              'إضافة مريض جديد',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              print('ابحث عن مريض');
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
            icon: const Icon(Icons.cloud_upload, color: Colors.green),
            label: Text(
              'حفظ في جوجل درايف',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _downloadFromGoogleDrive,
            icon: const Icon(Icons.cloud_download, color: Colors.green),
            label: Text(
              'استعادة من جوجل درايف',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              print('تحويل إلى ملف اكسل');
            },
            icon: const Icon(Icons.swap_horiz, color: Colors.green),
            label: Text(
              'تحويل إلى ملف اكسل',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _sendDatabaseByEmail,
            icon: const Icon(Icons.backup, color: Colors.blue),
            label: Text(
              'إرسال نسخة احتياطية بالإيميل',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 20,
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
                  content: Text(success ? 'تم تسجيل الدخول بنجاح' : 'فشل تسجيل الدخول'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
              _checkSignInStatus();
            },
            icon: const Icon(Icons.login, color: Colors.purple),
            label: Text(
              'اختبار تسجيل الدخول Google',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 16,
                color: Colors.purple,
              ),
            ),
          ),
                    // Add this button temporarily for debugging
          ElevatedButton.icon(
            onPressed: () async {
              // Check environment configuration
              print('=== DEBUG INFO ===');
              print('Client ID from env: ${EnvConfig.googleOAuthClientId}');
              print('Has Google Credentials: ${EnvConfig.hasGoogleCredentials}');
              print('Client ID length: ${EnvConfig.googleOAuthClientId.length}');
              // print('Client ID starts with: ${EnvConfig.googleOAuthClientId.substring(0, 20)}...');
              
              // Check package name
              print('Expected package: com.example.patients_data');
              
              // Show dialog with info
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Debug Info'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Has Client ID: ${EnvConfig.hasGoogleCredentials}'),
                      Text('Client ID Length: ${EnvConfig.googleOAuthClientId.length}'),
                      if (EnvConfig.hasGoogleCredentials)
                        Text('Client ID: ${EnvConfig.googleOAuthClientId.substring(0, 20)}...'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.bug_report),
            label: Text('Debug Config'),
          ),
        ],
      ),
    );
  }
}
