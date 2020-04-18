import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  final String dp;
  final String name;
  final String msg;
  final bool isOnline;
  final Function onTap;
  final Widget trailing;
  final bool isRoom;

  ChatItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.msg,
    @required this.isOnline,
    @required this.onTap,
    @required this.trailing,
    @required this.isRoom,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.dp,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              width: 50,
              height: 50,
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
                  color: widget.isOnline
                      ? Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 12,
                width: 12,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isOnline
                          ? Colors.greenAccent
                          : Colors.transparent,
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
        title: Text(
          "${widget.name}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("${widget.msg}"),
        trailing: widget.trailing,
        dense: true,
        onTap: widget.onTap,
      ),
    );
  }
}
