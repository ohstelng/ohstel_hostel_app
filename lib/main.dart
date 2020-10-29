import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ohstel_hostel_app/hostel_booking/hoste_home_page.dart';

import 'hive_methods/hive_class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init hive
  await InitHive().startHive(boxName: 'userDataBox');

  // init Firebase
  await Firebase.initializeApp();

  //run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HostelHomePage(),
    );
  }
}
