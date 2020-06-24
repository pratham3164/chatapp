import 'package:chatsapp/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, messageSnapshot) {
                if (messageSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatdoc = messageSnapshot.data.documents;
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) {
                    return Container(
                      margin: index == chatdoc.length - 1
                          ? EdgeInsets.only(top: 10)
                          : null,
                      child: MessageBubble(
                        key: ValueKey(chatdoc[index].documentID),
                        message: chatdoc[index]['text'],
                        username: chatdoc[index]['username'],
                        url: chatdoc[index]['image_url'],
                        isMe: chatdoc[index]['uid'] == authSnapshot.data.uid,
                      ),
                    );
                  },
                  itemCount: chatdoc.length,
                );
              });
        });
  }
}
