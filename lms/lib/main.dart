import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import 'package:lms/screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/create_class.dart';
import './screens/demo.dart';
import './screens/classscreen.dart';
import './screens/uploadscreen.dart';
import './screens/classmaterial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Syne',
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
      ),
      title: 'LMS',
      debugShowCheckedModeBanner: false,
      home: Demo(),
      routes: {
        CreateClass.routeName: (ctx) => CreateClass(),
        ClassScreen.routeName:(ctx)=>ClassScreen(),
        UploadScreen.routeName:(ctx)=>UploadScreen(),
        ClassMaterial.routeName:(ctx)=>ClassMaterial(),
      },
    );
  }
}
