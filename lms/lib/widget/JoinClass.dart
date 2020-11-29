import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:lms/screens/classscreen.dart';

class JoinClass extends StatefulWidget {
  @override
  _JoinClassState createState() => _JoinClassState();
}

class _JoinClassState extends State<JoinClass> {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  final User _user = FirebaseAuth.instance.currentUser;

  final _controller = TextEditingController();

  bool _isValid = false;
  bool _isLoading = false;

  void _checkId() async {
    final id = _controller.text;
    int flag = 0;

    setState(() {
      _isLoading = true;
    });

    // print(id);
    if (id.trim().isEmpty || id.trim().length < 12 || id.trim().contains(" ")) {
      setState(() {
        _isValid = true;
        _isLoading = false;
      });

      return;
    }

    final docs = await _instance.collection("join_class").get();

    final allDocs = docs.docs;

    final data =
        await _instance.collection("check").doc(_user.uid).get();
    List<dynamic> data1 = data.data().containsKey('joined')?data.data()['joined']:[];
    // print(allDocs[0].id);
    print(data1);

    for (int i = 0; i < docs.size; i++) {
      if (allDocs[i].id == id) {
        flag = 1;
        final prevStud = await _instance.collection("join_class").doc(id).get();
        List studData = prevStud.data()['students'];
        final facultyId = prevStud.data()['uid'];

        // List<Map<String, dynamic>> data2 = [];

        if (studData.indexOf(_user.uid) == -1) {
          studData.add(_user.uid);
          await _instance
              .collection("join_class")
              .doc(id)
              .update({'students': studData});
          // data2.add({
          //   'facid': facultyId,
          //   'classid': id,
          // });
          data1.add({'facid': facultyId, 'classid': id});
          

          await _instance
              .collection("check")
              .doc(_user.uid)
              .update({'joined': data1});

          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(ClassScreen.routeName,arguments: [id,facultyId]);

          // print("success");
        } else {
          showDialog(
            context: context,
            child: AlertDialog(
              content: Text("You have already joined this class"),
              title: Text(
                "Error Occured!!!",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Okay",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        break;
      }
    }

    if (flag == 0 && _isValid == false) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Error Occured!!!"),
          content: Text(
            "No class exists with this Class Id",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });

    setState(() {
      _isValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  errorText: _isValid ? 'Enter valid Class Id ' : null,
                  hintText: 'Enter Class Id*',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(width: 2, color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  onPressed: _isLoading
                      ? () {}
                      : () {
                          _checkId();
                        },
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Join Class",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                  padding: EdgeInsets.all(15),
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}