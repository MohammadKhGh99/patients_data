import 'package:flutter/material.dart';
import 'package:patients_data/add_patient.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
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

  @override
  Widget build(BuildContext context) {
    Widget page = MainMenuPage(
      onButtonPressed: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
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
          onButtonPressed: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
        );
      case 1:
        page = AddPatientPage(
          onButtonPressed: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
        );
      // case 2:
      //   page = SearchPatientPage();
      // case 3:
      //   page = SearchResultsPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: widget.title),
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 100),
          ElevatedButton.icon(
            onPressed: () {
              print('إضافة مريض جديد');
              widget.onButtonPressed(1);
            },
            icon: const Icon(Icons.add, color: Colors.black),
            label: Text(
              'إضافة مريض جديد',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              print('ابحث عن مريض');
              // widget.onButtonPressed(2);
            },
            icon: const Icon(Icons.search, color: Colors.black),
            label: Text(
              'ابحث عن مريض',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              print('حفظ في جوجل درايف');
            },
            icon: const Icon(Icons.add_to_drive, color: Colors.green),
            label: Text(
              'حفظ في جوجل درايف',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 15,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              print('استعادة من جوجل درايف');
            },
            icon: const Icon(Icons.restore, color: Colors.green),
            label: Text(
              'استعادة من جوجل درايف',
              style: GoogleFonts.scheherazadeNew(
                fontSize: 15,
                color: Colors.black,
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
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
