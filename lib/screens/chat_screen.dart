import 'package:chatsapp/widgets/chat/messages.dart';
import 'package:chatsapp/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fm = FirebaseMessaging();
    fm.requestNotificationPermissions();
    fm.configure(onMessage: (message) {
      print(message);
      return;
    }, onResume: (message) {
      print(message);
      return;
    }, onLaunch: (message) {
      print(message);
      return;
    });
    fm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chats'),
        actions: <Widget>[
          DropdownButton(
              icon: Icon(Icons.more_vert, color: Colors.white               ),
              underline: Container(),
              items: [
                DropdownMenuItem(
                    value: 'Logout',
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text('Logout')
                        ],
                      ),
                    ))
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'Logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(child: Messages()),
          NewMessage(),
        ],
      )),
      // StreamBuilder(
      //     stream: Firestore.instance
      //         .collection('chats/6yY8fo3yC8IAlXTXagYc/messages')
      //         .snapshots(),
      //     builder: (context, streamSnapshot) {
      //       if (streamSnapshot.connectionState == ConnectionState.waiting) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       final documents = streamSnapshot.data.documents;
      //       return ListView.builder(
      //         itemCount: documents.length,
      //         itemBuilder: (ctx, index) {
      //           return Text(documents[index]['text']);
      //         },
      //       );
      //     }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Firestore.instance
      //         .collection('chats/6yY8fo3yC8IAlXTXagYc/messages')
      //         .add({'text': 'this text was added now!'});
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
