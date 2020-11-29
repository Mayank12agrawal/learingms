import 'package:flutter/material.dart';
import 'package:lms/widget/app_drawer.dart';
import '../widget/createclassform.dart';

class CreateClass extends StatelessWidget {
  static const routeName = '/createclass';
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
              icon: Icon(Icons.home),
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(7),
            child: Container(
              padding: EdgeInsets.all(8),
              child: CreateForm(),
    ),),
    );
  }
}
