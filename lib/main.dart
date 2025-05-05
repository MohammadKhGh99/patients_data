import 'package:flutter/material.dart';

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
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
              ElevatedButton.icon(
                onPressed: () {
                  // Add your onPressed logic here
                  print('إضافة مريض جديد');
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
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Add your onPressed logic here
                  print('ابحث عن مريض');
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
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Add your onPressed logic here
                  print('حفظ في جوجل درايف');
                },
                icon: const Icon(Icons.add_to_drive, color: Colors.green),
                label: const Text(
                  'حفظ في جوجل درايف',
                  style: TextStyle(fontSize: 15, fontFamily: 'ScheherazadeNew'),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Add your onPressed logic here
                  print('استعادة من جوجل درايف');
                },
                icon: const Icon(Icons.restore, color: Colors.green),
                label: const Text(
                  'استعادة من جوجل درايف',
                  style: TextStyle(fontSize: 15, fontFamily: 'ScheherazadeNew'),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Add your onPressed logic here
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
        ),
      ),
    );
  }
}

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key, required this.title});
  final Text title;

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ),
    );
  }
}
