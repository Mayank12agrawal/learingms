import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/signin.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        child: Center(
          child: FlatButton(
            child: isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: 50,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign in with',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Image.asset(
                          'Assets/images/googlelogo.png',
                          height: 35,
                        ),
                      ],
                    ),
                  ),
            onPressed: () {
              setState(() {
                isloading = true;
              });
              signwithgoogle();
              setState(() {
                isloading = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
