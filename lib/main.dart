import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/methods/auth_methods.dart';
import 'auth/models/login_user_model.dart';
import 'auth/wrapper.dart';
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
    return StreamProvider<LoginUserModel>.value(
      value: AuthService().userStream,
      child: MaterialApp(
        title: 'Ohstel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xfff27507),
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}
