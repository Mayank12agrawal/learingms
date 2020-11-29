import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import "../screens/classscreen.dart";
import 'package:share/share.dart';

class ClassList extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _instance = FirebaseFirestore.instance;

  String facultyId;
  int totalclass = 0;
  Future<dynamic> check() async {
    if (user.email.startsWith(RegExp(r'[0-9]'))) {
      final studData =
          await _instance.collection("check").doc(user.uid).get();
      if (studData.data()!=null) {
        List<dynamic> joinedClasses = studData.data()['joined'];
        totalclass = joinedClasses.length;

        List<Map<String, dynamic>> joinClasses = [];

        // print(joinedClasses);

        for (int i = 0; i < joinedClasses.length; i++) {
          final eachClass = await _instance
              .collection('newclass')
              .doc(joinedClasses[i]['facid'])
              .collection('totalclass')
              .doc(joinedClasses[i]['classid'])
              .get();
          joinClasses.add(
            eachClass.data(),
          );
          // print(joinClasses);
        }

        return joinClasses;
      }
    } else {
      // print("sshgjagsdj0");
    }
    // return  ;
  }
  
  Future<void> facId(classId) async {
    await _instance.collection("join_class").doc(classId).get().then((value) {
      facultyId = value.data()['uid'];
      print(facultyId);
    });
  }

  Future<bool> imagecheck() async {
    final data = await _instance.collection('check').doc(user.uid).get();
    Map<String, dynamic> classes = data.data();
    if (classes!=null) {
      int length = classes['joined'].length;
      if (length == 0) {
        return true;
      }
      return false;
    }
    return true;
  }

  share(BuildContext context,final classid)
  {
    final RenderBox box = context.findRenderObject();
    Share.share(classid,
        subject: classid,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    // check();

    return FutureBuilder(
      future: user.email.startsWith(RegExp(r'[0-9]'))
          ? check()
          : _instance
              .collection('newclass')
              .doc(user.uid)
              .collection('totalclass')
              .orderBy('createdate', descending: true)
              .get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // if(user.email.startsWith(RegExp(r'[0-9]'))){

        // }
        // print(snapshot.data);

        // if (user.email.startsWith(RegExp(r'[0-9]'))) {
        //   if( await imagecheck()){

        //   }
        // }

        return user.email.startsWith(RegExp(r'[0-9]')) && totalclass == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.asset(
                        'Assets/images/empty_class.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Join a Class To get Started',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        letterSpacing: 0.2),
                  ),
                ],
              )
            : Container(
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                  itemBuilder: (ctx, index) => GestureDetector(
                    onTap: () async {
                      user.email.startsWith(RegExp(r'[0-9]'))
                          ? await facId(snapshot.data[index]['classid'])
                          : print("classroom");
                      // print(facultyId);

                      Navigator.of(context).pushNamed(
                        ClassScreen.routeName,
                        arguments: user.email.startsWith(RegExp(r'[0-9]'))
                            // ? snapshot.data['classid']
                            ? [
                                snapshot.data[index]['classid'],
                                facultyId,
                              ]
                            : [snapshot.data.documents[index]['classid'], null],
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                            image: AssetImage('Assets/images/display.jpg'),
                            fit: BoxFit.cover),
                        border: Border.all(width: 1, color: Colors.black26),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email.startsWith(RegExp(r'[0-9]'))
                                // ? snapshot.data['title']
                                ? snapshot.data[index]['title']
                                : snapshot.data.documents[index]['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            user.email.startsWith(RegExp(r'[0-9]'))
                                // ? snapshot.data['sem'].toString()
                                ? 'SEM-   ${snapshot.data[index]['sem'].toString()}'
                                : 'SEM-   ${snapshot.data.documents[index]['sem'].toString()}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            user.email.startsWith(RegExp(r'[0-9]'))
                                ? 'SECTION- ${snapshot.data[index]['section']}'
                                : 'SECTION- ${snapshot.data.documents[index]['section']}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          if(user.email.startsWith(RegExp(r'[0-9]'))) SizedBox(
                            height: 15,
                          ),
                          Row(children: [
                            Text(
                              user.email.startsWith(RegExp(r'[0-9]'))
                                  // ? snapshot.data['date']
                                  ? snapshot.data[index]['classid']
                                  : snapshot.data.documents[index]['classid'],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                           if(!user.email.startsWith(RegExp(r'[0-9]'))) IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.content_copy,
                                  size: 17,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: snapshot.data.documents[index]['classid'],
                                    ),
                                  );
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Copied Successfully')));
                                }),
                            if(!user.email.startsWith(RegExp(r'[0-9]'))) IconButton(
                                icon: Icon(
                                  Icons.share,
                                  size: 17,
                                  color: Colors.black87,
                                ),
                                onPressed:()=> share(context,snapshot.data.documents[index]['classid']))
                          ]),
                        ],
                      ),
                    ),
                  ),
                  itemCount: user.email.startsWith(RegExp(r'[0-9]'))
                      ? snapshot.data.length
                      : snapshot.data.documents.length,
                ),
              );
      },
    );
  }
}
