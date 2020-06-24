import 'package:chatsapp/screens/auth_screen.dart';
import 'package:chatsapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          // primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ChatScreen();
              }
              return AuthScreen();
            }));
  }
}
