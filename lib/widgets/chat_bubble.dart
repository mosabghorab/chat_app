import 'dart:math';

import 'package:chat_app/utils/enums.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message, time, username;
  final MessageType messageType;
  final bool isMe;
  final bool isRoom;

  ChatBubble({
    @required this.message,
    @required this.time,
    @required this.isMe,
    @required this.username,
    @required this.messageType,
    @required this.isRoom,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  @override
  Widget build(BuildContext context) {
    final bg = widget.isMe ? Colors.blue : Colors.grey[200];
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = widget.isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(15.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          );
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        widget.isMe
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.username.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      width: 45,
                      height: 45,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.isRoom ? Colors.blue : Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.isRoom ? 18 : 30),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 6.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        height: 12,
                        width: 12,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            height: 8,
                            width: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: align,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: radius,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.3,
                minWidth: 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(
                        widget.messageType == MessageType.TEXT_MESSAGE ? 5 : 0),
                    child: widget.messageType == MessageType.TEXT_MESSAGE
                        ? Text(
                            widget.message,
                            style: TextStyle(
                                color:
                                    widget.isMe ? Colors.white : Colors.black,
                                fontSize: 15),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: widget.isMe
                  ? EdgeInsets.only(
                      right: 10,
                      bottom: 10.0,
                    )
                  : EdgeInsets.only(
                      left: 10,
                      bottom: 10.0,
                    ),
              child: Text(
                widget.time,
                style: TextStyle(
                  color: Theme.of(context).textTheme.subtitle.color,
                  fontSize: 10.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
