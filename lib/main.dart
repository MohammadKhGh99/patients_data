import 'package:flutter/material.dart';
import 'package:patients_data/add_patient.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  @override
  Widget build(BuildContext context) {
    Widget page = MainMenuPage(
      onButtonPressed: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
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
        page = AddPatientPage();
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 150),
              page,
            ],
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
            ElevatedButton.icon(
              onPressed: () {
                print('إضافة مريض جديد');
                widget.onButtonPressed(1);
              },
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'إضافة مريض جديد',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'ScheherazadeNew',
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
              label: const Text(
                'ابحث عن مريض',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'ScheherazadeNew',
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
              label: const Text(
                'حفظ في جوجل درايف',
                style: TextStyle(fontSize: 15, fontFamily: 'ScheherazadeNew'),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                print('استعادة من جوجل درايف');
              },
              icon: const Icon(Icons.restore, color: Colors.green),
              label: const Text(
                'استعادة من جوجل درايف',
                style: TextStyle(fontSize: 15, fontFamily: 'ScheherazadeNew'),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                print('تحويل إلى ملف اكسل');
              },
              icon: const Icon(Icons.swap_horiz, color: Colors.green),
              label: const Text(
                'تحويل إلى ملف اكسل',
                style: TextStyle(fontSize: 15, fontFamily: 'ScheherazadeNew'),
              ),
            ),
          ],
        ),
    );
  }
}
