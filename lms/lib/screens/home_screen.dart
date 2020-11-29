import 'package:flutter/material.dart';
import 'package:lms/screens/create_class.dart';
import '../widget/app_drawer.dart';
import '../widget/class_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/JoinClass.dart';

class HomeScreen extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  void joinclass(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return JoinClass();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(
            'Classroom',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => user.email.startsWith(RegExp(r'[0-9]'))
                  ? joinclass(context)
                  : Navigator.of(context)
                      .pushReplacementNamed(CreateClass.routeName),
            ),
          ],
        ),
        body: ClassList());
  }
}
