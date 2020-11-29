import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "dart:io";
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFormWidget extends StatefulWidget {
  final classId;
  String title1;
  String desc1;
  String cat1;
  String uploadid1;
  final editfiles1;

  UploadFormWidget(this.classId, this.title1, this.desc1, this.cat1,
      this.uploadid1, this.editfiles1);
  @override
  _UploadFormWidgetState createState() => _UploadFormWidgetState();
}

class _UploadFormWidgetState extends State<UploadFormWidget> {
  final _sub1 = GlobalKey<FormState>();
  String _value;
  int file_count = 0;
  int i = 0;
  bool isloading = false;

  List<Map<String, String>> files = [];
  @override
  void initState() {
    if (widget.editfiles1 == [] || widget.editfiles1 != []) {
      file_count = widget.editfiles1.length;
      // files = widget.ed_files;
      // print(widget.ed_files[0]['name']);

      for (int i = 0; i < file_count; i++) {
        Map<String, String> edSFile = {
          'name': widget.editfiles1[i]['name'],
          'extension': widget.editfiles1[i]['extension'],
          'path': widget.editfiles1[i]['path'],
          'index': widget.editfiles1[i]['index'],
        };
        files.add(edSFile);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.title1);
    print(widget.desc1);
    print(widget.cat1);
    print(widget.uploadid1);
    print(widget.editfiles1);
    String title;
    String cat;
    String desc;
    String _error;
    Future<void> _takeFile() async {
      FocusScope.of(context).unfocus();
      FilePickerResult result = await FilePicker.platform.pickFiles();

      // print(result.count);
      if (result != null) {
        setState(() {
          file_count += result.count;
        });
        PlatformFile file = result.files.first;
        Map<String, String> S_file = {
          'name': file.name,
          'extension': file.extension,
          'path': file.path,
          'index': (i++).toString(),
        };
        print(S_file['extension']);
        files.add(S_file);
      } else {}
    }

    void delete(int i) {
      files.removeAt(i);
      setState(() {
        file_count = file_count - 1;
      });
    }

    void trysubmit() async {
      FocusScope.of(context).unfocus();
      setState(() {
        isloading = true;
      });
      final isvalid = _sub1.currentState.validate();
      if (!isvalid) {
        setState(() {
          isloading = false;
        });
        return;
      }

      _sub1.currentState.save();

      FirebaseFirestore _data = FirebaseFirestore.instance;
      User _user = FirebaseAuth.instance.currentUser;
      final time = DateTime.now();
      final time1 = DateTime.now().hour;
      final time2 = DateTime.now().minute;
      final time3 = DateTime.now().millisecond;
      final userid = _user.uid.substring(0, 6);
      final classid = '$userid$time1$time2$time3';
      final classid1 = '$time1$time2$time3';
      final date = DateFormat('dd-MM-yyyy').format(time);

      try {
        if (file_count != 0) {
          for (int i = 0; i < file_count; i++) {
            if (files[i]['extension'] == 'jpg' ||
                files[i]['extension'] == 'jpeg' ||
                files[i]['extension'] == 'png' ||
                files[i]['extension'] == 'docx' ||
                files[i]['extension'] == 'doc' ||
                files[i]['extension'] == 'pdf' ||
                files[i]['extension'] == 'ppt' ||
                files[i]['extension'] == 'pptx') {
              final ref = FirebaseStorage.instance
                  .ref()
                  .child('uploads')
                  .child(_user.email)
                  .child('${files[i]['name']}$classid1' +
                      '.' +
                      '${files[i]['extension']}');

              final up_file =
                  await ref.putFile(File(files[i]['path'])).onComplete;
              final url = await up_file.ref.getDownloadURL();

              files[i]['url'] = url.toString();
              files[i]['classId'] = widget.classId.toString();

              print(files[i]['classId']);
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Error! Check File Extensions',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.redAccent,
                ),
              );
              break;
            }
          }
        }
        print(title);
        await _data
            .collection('uploads')
            .doc(_user.uid)
            .collection(widget.classId)
            .doc(widget.uploadid1==null?'${widget.classId}$classid1':widget.uploadid1)
            .set({
          'title': title.trim(),
          'category': cat,
          'description': desc.trimRight(),
          'classid': widget.classId,
          'date': date,
          'files': files,
          'createdat': time,
          'id': widget.uploadid1==null?
                '${widget.classId}$classid1'
                 :widget.uploadid1,
        });
      } catch (error) {
        _error = error.message;
      }
      if (_error == null) {
        _sub1.currentState.reset();
        file_count = 0;
        files = [];
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('data uploaded successfully'),
        ));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Something Went Wrong'),
        ));
      }
      setState(() {
        isloading = false;
      });
    }

    return Form(
      key: _sub1,
      child: ListView(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Upload",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            // focusNode: _titleNode,
            initialValue: widget.title1==null?'':widget.title1,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.next,
            // onFieldSubmitted: (_) =>
            //     FocusScope.of(context).requestFocus(_semNode),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please Enter Title';
              }

              return null;
            },
            onSaved: (value) {
              title = value;
            },
            decoration: InputDecoration(
              hintText: 'Title*',
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
            height: 15,
          ),
          DropdownButtonFormField(
            // focusNode: _catNode,
            value: widget.cat1==null?_value:widget.cat1,
            onSaved: (value) {
              cat = value;
            },
            validator: (value) {
              if (value == null) {
                return "Please Select Category";
              }
              return null;
            },
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
            hint: Text('Category*'),
            items: [
              DropdownMenuItem(
                child: Text('Notes'),
                value: 'notes',
              ),
              DropdownMenuItem(
                child: Text('Assignment'),
                value: 'assign',
              ),
            ],
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            minLines: 1,
            maxLines: 10,
            // focusNode: _desNode,
            // cursorColor: Colors.black,

            onSaved: (value) {
              desc = value;
            },

            decoration: InputDecoration(
            
              hintText: 'Description',
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(width: 2, color: Colors.black)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            ),
            initialValue: widget.desc1==null?'':widget.desc1,
          ),
          SizedBox(
            height: 15,
          ),
          OutlineButton(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            child: Text('Upload Files'),
            onPressed: _takeFile,
          ),
          if (file_count != 0)
            SizedBox(
              height: 15,
            ),
          if (file_count != 0)
            Container(
              padding: EdgeInsets.all(10),
              height: file_count < 2 ? 110 : 200,
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
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => delete(index),
                      ),
                    ),
                  );
                },
                itemCount: file_count,
              ),
            ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            onPressed: isloading ? () {} : trysubmit,
            padding: EdgeInsets.all(15),
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: isloading
                ? SizedBox(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.black87,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white)),
                    width: 25,
                    height: 25,
                  )
                : Text(
                    "Upload",
                    style: TextStyle(
                        fontSize: 18, color: Colors.white, letterSpacing: 1),
                  ),
          ),
        ],
      ),
    );
  }
}
