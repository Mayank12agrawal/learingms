import 'package:flutter/material.dart';
import 'package:lms/widget/uploadform.dart';
import '../widget/app_drawer.dart';

class UploadScreen extends StatelessWidget {
  static const routeName = '/uploadscreen';
  @override
  Widget build(BuildContext context) {
    List id = ModalRoute.of(context).settings.arguments;
    final classid = id[0];
    final title = id[1];
    final desc = id[2];
    final cat = id[3];
    final uploadid = id[4];
    final files = id[5];
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
          child: UploadFormWidget(classid, title, desc, cat,uploadid, files),
        ),
      ),
    );
  }
}
