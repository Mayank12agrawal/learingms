import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class ClassMaterial extends StatelessWidget {
  static const routeName = '/classmaterial';
  @override
  Widget build(BuildContext context) {
    List ids = ModalRoute.of(context).settings.arguments;
    final docid = ids[0];
    final classid = ids[1];
    final facid = ids[2];
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore _instance = FirebaseFirestore.instance;
    return Scaffold(
        backgroundColor: Colors.white,
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
        ),
        body: FutureBuilder(
          future: _instance
              .collection('uploads')
              .doc(user.email.startsWith(RegExp(r'[0-9]'))?facid:user.uid)
              .collection(classid)
              .doc(docid)
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final files = snapshot.data['files'];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data['title'],
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            height: 1.3),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      snapshot.data['description'] == ''
                          ? Text('No Description',
                              style: TextStyle(
                                color: Colors.grey,
                              ))
                          : SelectableText(
                              snapshot.data['description'],
                              style: TextStyle(
                                  letterSpacing: 0.3,
                                  height: 1.3,
                                  fontSize: 15),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Attachments',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 10),
                      files.length == 0
                          ? Text(
                              'No attachements',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(10),
                              height: files.length < 2 ? 110 : 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.builder(
                                itemBuilder: (ctx, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    height: 65,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        files[index]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        maxLines: 1,
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: Colors.black54,
                                        ),
                                        onPressed: () async {
                                          if (await canLaunch(
                                              files[index]['url'])) {
                                            await launch(files[index]['url']);
                                          } else {
                                            print('could not mtch');
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                                itemCount: files.length,
                              ),
                            )
                    ],
                  ))
                ]),
              );
            }
          },
        ));
  }
}
