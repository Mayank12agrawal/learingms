import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _sub = GlobalKey<FormState>();
  int _value = 0;
  Map<String, Object> _data = {
    'title': null,
    'sem': null,
    'section': null,
    'subjectcode': null,
  };
  final _titlenode = FocusNode();
  final _sectionenode = FocusNode();
  final _subjectnode = FocusNode();
  final _semnode = FocusNode();
  @override
  void dispose() {
    // TODO: implement dispose
    _titlenode.dispose();
    _sectionenode.dispose();
    _subjectnode.dispose();
    _semnode.dispose();
    super.dispose();
  }

  void _saveform() async {
    final isvalid = _sub.currentState.validate();
    if (!isvalid) {
      return;
    }
    FocusScope.of(context).unfocus();
    _sectionenode.unfocus();
    _titlenode.unfocus();
    _subjectnode.unfocus();

    _sub.currentState.save();
    _sub.currentState.reset();

    FirebaseFirestore _dat = FirebaseFirestore.instance;
    User _user = FirebaseAuth.instance.currentUser;
    final time = DateTime.now();
    final time1 = DateTime.now().hour;
    final time2 = DateTime.now().minute;
    final time3 = DateTime.now().millisecond;
    final userid = _user.uid.substring(0, 6);
    final classid = '$userid$time1$time2$time3';
    final date = DateFormat('dd-MM-yyyy').format(time);
    await _dat
        .collection('newclass')
        .doc(_user.uid)
        .collection('totalclass')
        .doc(classid)
        .set({
      'title': _data['title'],
      'sem': _data['sem'],
      'section': _data['section'],
      'subjectcode': _data['subjectcode'],
      'createdate': time,
      'date': date,
      'classid': classid,
      'name':_user.displayName,
      'facid':_user.uid,
    });
    await _dat.collection('join_class').doc(classid).set({
      'uid':_user.uid,
      'students': []});
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(seconds: 5),
      content: Text('Class Created Successfully'),
    ));
    String username = '003mayanktry@gmail.com';
    String password = 'mayank@123';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Classroom')
      ..recipients.add(_user.email)
      ..subject = 'Class ID'
      ..text = '$classid';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _sub,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Create Class',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[900],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'please enter class title';
              }
              return null;
            },
            onSaved: (value) {
              _data['title'] = value;
            },
            focusNode: _titlenode,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_semnode),
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Class Title*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 10),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          DropdownButtonFormField(
              validator: (value) {
                if (value == null) {
                  return 'please choose semester';
                }
                return null;
              },
              onSaved: (value) {
                _data['sem'] = value;
              },
              focusNode: _semnode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              ),
              hint: Text('SEM*'),
              items: [
                DropdownMenuItem(
                  child: Text('1'),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text('2'),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text('3'),
                  value: 3,
                ),
                DropdownMenuItem(
                  child: Text('4'),
                  value: 4,
                ),
                DropdownMenuItem(
                  child: Text('5'),
                  value: 5,
                ),
                DropdownMenuItem(
                  child: Text('6'),
                  value: 6,
                ),
                DropdownMenuItem(
                  child: Text('7'),
                  value: 7,
                ),
                DropdownMenuItem(
                  child: Text('8'),
                  value: 8,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  value = _value;
                });
              }),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'please enter Section';
              }
              return null;
            },
            onSaved: (value) {
              _data['section'] = value;
            },
            focusNode: _sectionenode,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_subjectnode),
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Section*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 10),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'please enter Subject code';
              }
              return null;
            },
            onSaved: (value) {
              _data['subjectcode'] = value;
            },
            focusNode: _subjectnode,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Subject Code*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 10),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          FlatButton(
            padding: EdgeInsets.all(15),
            onPressed: _saveform,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.black,
            child: Text(
              'Create',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
