import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController _controller = TextEditingController();
  String _enteredText = '';
  FirebaseUser user;
  DocumentSnapshot username;

  Future<void> getData() async {
    user = await FirebaseAuth.instance.currentUser();
    username =
        await Firestore.instance.collection('users').document(user.uid).get();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> saveText() async {
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('chat').add({
      'text': _enteredText.trim(),
      'createdAt': Timestamp.now(),
      'uid': user.uid,
      'username': username['username'],
      'image_url': username['image_url']
    });

    setState(() {
      _enteredText = '';
      print('cleared');
      _controller.clear();
    });
  }

  // @override
  // void dispose() {
  //   print('dispose calles');
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print(_enteredText.trim());
    return Container(
      child: Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'new message'),
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _enteredText = value;
                });
              },
            ),
          ),
        ),
        IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.send),
          onPressed: _enteredText.trim().isEmpty ? null : saveText,
        )
      ]),
    );
  }
}
