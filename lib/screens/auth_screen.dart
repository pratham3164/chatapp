import 'dart:io';

import 'package:chatsapp/widgets/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  bool _saving = false;

  Future<void> submitForm(
    BuildContext context,
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
  ) async {
    AuthResult authResult;
    setState(() {
      _saving = true;
    });
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(authResult.user.uid + '.jpg');
      await ref.putFile(image).onComplete;
      final url = await ref.getDownloadURL();
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'username': username,
        'email': email,
        'image_url': url,
      });
    } on PlatformException catch (err) {
      String message = 'An error occurred,please check your credentials';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    } catch (err) {
      print(err);
    }

    setState(() {
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ModalProgressHUD(inAsyncCall: _saving, child: AuthCard(submitForm)),
    );
  }
}
