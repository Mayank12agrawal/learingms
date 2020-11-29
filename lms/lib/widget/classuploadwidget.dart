import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lms/screens/uploadscreen.dart';
import '../screens/classmaterial.dart';

class ClassUpload extends StatelessWidget {
  String classid;
  String facid;
  ClassUpload(this.classid, this.facid);
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore _instance = FirebaseFirestore.instance;
    final time1 = DateTime.now().hour;
    final time2 = DateTime.now().minute;
    final time3 = DateTime.now().millisecond;
    final classid1 = '$time1$time2$time3';
    return StreamBuilder(
      stream: _instance
          .collection('uploads')
          .doc(user.email.startsWith(RegExp(r'[0-9]')) ? facid : user.uid)
          .collection(classid)
          .orderBy('createdat', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return snapshot.data.size == 0
            ? Column(
               
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Center(
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset(
                          'Assets/images/paper.png',
                          fit: BoxFit.cover,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No uploads yet, but check again soon',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ])
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 30),
                itemBuilder: (ctx, index) {
                  final docid = snapshot.data.documents[index]['id'];
                  return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black12)),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                          onTap: () => user.email.startsWith(RegExp(r'[0-9]'))
                              ? Navigator.of(context).pushNamed(
                                  ClassMaterial.routeName,
                                  arguments: [docid, classid, facid])
                              : Navigator.of(context).pushNamed(
                                  ClassMaterial.routeName,
                                  arguments: [docid, classid, facid]),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 25,
                            child: snapshot.data.documents[index]['category'] ==
                                    'notes'
                                ? Text(
                                    'N',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                : Text(
                                    'A',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data.documents[index]['title'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                snapshot.data.documents[index]['date'],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: user.email.startsWith(RegExp(r'[0-9]'))
                              ? FlatButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(ClassMaterial.routeName,
                                          arguments: [docid, classid, facid]),
                                  child: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.grey,
                                    size: 25,
                                  ))
                              : PopupMenuButton(
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            child: ListTile(
                                                trailing: Icon(Icons.edit,
                                                    color: Colors.black87),
                                                title: Text('edit'),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          UploadScreen
                                                              .routeName,
                                                          arguments: [
                                                        classid,
                                                        snapshot.data.documents[
                                                            index]['title'],
                                                        snapshot.data.documents[
                                                                index]
                                                            ['description'],
                                                        snapshot.data.documents[
                                                            index]['category'],
                                                        snapshot.data.documents[
                                                            index]['id'],
                                                        snapshot.data.documents[
                                                            index]['files'],
                                                      ]);
                                                })),
                                        PopupMenuItem(
                                          child: ListTile(
                                            trailing: Icon(Icons.delete_outline,
                                                color: Colors.redAccent),
                                            title: Text('delete'),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        title: Text(
                                                            'Are you sure?'),
                                                        content: Text(
                                                            'Do you want to delete this item'),
                                                        actions: [
                                                          FlatButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                              _instance
                                                                  .collection(
                                                                      'uploads')
                                                                  .doc(user.uid)
                                                                  .collection(
                                                                      classid)
                                                                  .doc(snapshot
                                                                          .data
                                                                          .documents[
                                                                      index]['id'])
                                                                  .delete();
                                                            },
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                            },
                                          ),
                                        ),
                                      ])
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.delete_outline,
                          //     color: Colors.redAccent,
                          //   ),
                          //   onPressed: () {
                          //     showDialog(
                          //         context: context,
                          //         builder: (ctx) => AlertDialog(
                          //               title: Text('Are you sure?'),
                          //               content:
                          //                   Text('Do you want to delete this item'),
                          //               actions: [
                          //                 FlatButton(
                          //                   onPressed: () {
                          //                     Navigator.of(ctx).pop();
                          //                     _instance
                          //                         .collection('uploads')
                          //                         .doc(user.uid)
                          //                         .collection(classid)
                          //                         .doc(snapshot.data.documents[index]
                          //                             ['id'])
                          //                         .delete();
                          //                   },
                          //                   child: Text(
                          //                     'Yes',
                          //                     style: TextStyle(
                          //                         color: Colors.black, fontSize: 14),
                          //                   ),
                          //                 ),
                          //                 FlatButton(
                          //                   onPressed: () {
                          //                     Navigator.of(ctx).pop();
                          //                   },
                          //                   child: Text(
                          //                     'No',
                          //                     style: TextStyle(
                          //                         fontSize: 14, color: Colors.black),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ));
                          //   },
                          // ),
                          ));
                },
                itemCount: snapshot.data.documents.length,
              );
      },
    );
  }
}
