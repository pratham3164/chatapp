import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String url;
  const MessageBubble(
      {Key key, this.message, this.username, this.url, this.isMe})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 40),
              margin: EdgeInsets.only(
                  left: isMe ? 10 : 5, right: isMe ? 5 : 30, bottom: 5),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: isMe ? Colors.grey : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight:
                        !isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (!isMe)
                    Text(username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                isMe ? Colors.limeAccent : Colors.greenAccent)),
                  Text(
                    message,
                    textWidthBasis: TextWidthBasis.longestLine,
                    // softWrap: true,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            if (!isMe)
              Positioned(
                  top: -7,
                  right: 7,
                  child: CircleAvatar(
                    backgroundImage: url != null ? NetworkImage(url) : null,
                    radius: 15,
                  ))
          ],
          overflow: Overflow.visible,
        ),
      ],
    );
  }
}
