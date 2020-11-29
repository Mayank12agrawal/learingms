import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

bool isfaculty = true;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();
GoogleSignInAccount googleSignInAccount;

Future<User> signwithgoogle() async {
  final GoogleSignInAccount account = await googleSignIn.signIn();

  final GoogleSignInAuthentication googleauth = await account.authentication;

  final AuthCredential usercredential = GoogleAuthProvider.credential(
    accessToken: googleauth.accessToken,
    idToken: googleauth.idToken,
  );
  final UserCredential userre =
      await _auth.signInWithCredential(usercredential);
  final user = userre.user;
  if (user.email.startsWith(RegExp(r'[0-9]'))) {
    isfaculty = false;
  } else {
    isfaculty = true;
  }
  await FirebaseFirestore.instance
      .collection(isfaculty ? 'faculty_user' : 'student_user')
      .doc(user.uid)
      .set({
    'email': user.email,
    'imageurl': user.photoURL,
    'username': user.displayName,
  });
  if (!isfaculty) {
    int flag = 0;
    final query1 = await FirebaseFirestore.instance.collection('check').get();
    final data = query1.docs;
    for (int i = 0; i < data.length; i++) {
      if (data[i].id == user.uid) {
        flag = 1;
        break;
      }
    }
    if (flag == 0) {
      await FirebaseFirestore.instance
          .collection('check')
          .doc(user.uid)
          .set({'joined': []});
    }
  }
  return user;
}

void signout(BuildContext context) {
  _auth.signOut();
  googleSignIn.signOut();
  Navigator.of(context).pushReplacementNamed('/');
  print('user log out');
}
