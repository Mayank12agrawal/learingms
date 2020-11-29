import 'package:flutter/material.dart';
import 'package:lms/screens/uploadscreen.dart';
import '../widget/app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/classuploadwidget.dart';

class ClassScreen extends StatelessWidget {
  static const routeName = '/classscreen';
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore _instance = FirebaseFirestore.instance;
    List classData = ModalRoute.of(context).settings.arguments;
    final classid = classData[0];
    final facId = classData[1];
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
      body: FutureBuilder(
        future: _instance
            .collection('newclass')
            .doc(user.email.startsWith(RegExp(r'[0-9]'))?facId:user.uid)
            .collection('totalclass')
            .doc(classid)
            .get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(image:DecorationImage(
                    image:AssetImage('Assets/images/image3.jpg'),
                    fit: BoxFit.cover
                  )),
                  padding: EdgeInsets.all(10),
                  
                  width: double.infinity,
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                          
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'SEM- ${snapshot.data['sem'].toString()}',
                        style: TextStyle(
                          fontSize: 16,
                           
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'SECTION- ${snapshot.data['section']}',
                        style: TextStyle(
                          fontSize: 16,
                           
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:ClassUpload(classid,facId),
                )
              ],
            ),
          );
        },
      ),
        floatingActionButton: user.email.startsWith(RegExp(r'[0-9]'))?null: FloatingActionButton(
        onPressed: ()=> Navigator.of(context).pushNamed(UploadScreen.routeName,arguments: [classid,null,null,null,null,[]]),
        tooltip: 'Upload',
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        elevation: 5,
      ),
    );
  }
}
