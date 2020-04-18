import 'package:chat_app/constants.dart' as constants;
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/room.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/notifiers/non_shared_notifiers/chat_screen_notifier.dart';
import 'package:chat_app/socket_obj.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_formatter/time_formatter.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatScreenNotifier(),
      child: ChatScreenBody(),
    );
  }
}

class ChatScreenBody extends StatefulWidget {
  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  GlobalKey<AnimatedListState> _animatedListGlobalKey = GlobalKey();
  TextEditingController _textEditingController = TextEditingController();
  List<Message> _messages = [];
  List _data;
  ChatScreenNotifier _chatScreenNotifier;
  bool _isFirstTime = true;

  Widget drawChatList() => AnimatedList(
        reverse: true,
        key: _animatedListGlobalKey,
        initialItemCount: _messages.length,
        itemBuilder: (context, index, anm) => SizeTransition(
          sizeFactor: anm,
          child: Container(
            width: double.infinity,
            child: ChatBubble(
              isRoom: false,
              message: _messages[index].content,
              time: _messages[index].date,
              isMe: currentUser.id == _messages[index].sender.id ? true : false,
              username: _messages[index].sender.name,
              messageType: MessageType.TEXT_MESSAGE,
            ),
          ),
        ),
      );

  void startListeners() {
    _data = ModalRoute.of(context).settings.arguments;
    if (_data[0] == ChatType.GENERAL_ROOM_CHAT) {
      socketIO.on(constants.EVENT_READ_GENERAL_ROOM_CHAT, (messages) {
        print('-00---------- yeah ------------');
        print(messages);
        for (var msg in messages) {
          Message message = Message.fromMap(msg);
          print(message.toMap());
          String date =
              formatTime(DateTime.parse(message.date).millisecondsSinceEpoch);
          message.date = date;
          _messages.insert(0, message);
          _animatedListGlobalKey.currentState
              .insertItem(0, duration: Duration(milliseconds: 500));
        }
      });
      socketIO.emit(constants.EVENT_READ_GENERAL_ROOM_CHAT, ['']);
      socketIO.on(constants.EVENT_SEND_GENERAL_ROOM_CHAT, (message) {
        Message msg = Message.fromMap(message);
        String date =
            formatTime(DateTime.parse(msg.date).millisecondsSinceEpoch);
        msg.date = date;
        _messages.insert(0, msg);
        _animatedListGlobalKey.currentState
            .insertItem(0, duration: Duration(milliseconds: 500));
      });
    } else if (_data[0] == ChatType.PRIVATE_CHAT) {
      socketIO.on(constants.EVENT_READ_PRIVATE_CHAT, (messages) {
        print('-----------here------------');
        print(messages);
        for (var msg in messages) {
          Message message = Message.fromMap(msg);
          String date =
              formatTime(DateTime.parse(message.date).millisecondsSinceEpoch);
          message.date = date;
          _messages.insert(0, message);
          _animatedListGlobalKey.currentState
              .insertItem(0, duration: Duration(milliseconds: 500));
        }
      });
      socketIO
          .emit(constants.EVENT_READ_PRIVATE_CHAT, [_data[1].toMap()['id']]);
      socketIO.on(constants.EVENT_SEND_PRIVATE_CHAT, (message) {
        Message msg = Message.fromMap(message);
        if (_data[1].toMap()['id'] == msg.sender.id ||
            msg.sender.id == currentUser.id) {
          String date =
              formatTime(DateTime.parse(msg.date).millisecondsSinceEpoch);
          msg.date = date;
          _messages.insert(0, msg);
          _animatedListGlobalKey.currentState
              .insertItem(0, duration: Duration(milliseconds: 500));
        }
      });
      socketIO.on(constants.EVENT_IS_TYPING, (isTyping) {
        _chatScreenNotifier.isTyping = isTyping;
//            _messages.insert(
//                0,
//                Message(
//                    content: '...',
//                    receiver: null,
//                    sender: data[1],
//                    room: null,
//                    date: ''));
//            _animatedListGlobalKey.currentState
//                .insertItem(0, duration: Duration(milliseconds: 500));
      });
    } else if (_data[0] == ChatType.ROOM_CHAT) {
      socketIO.on(constants.EVENT_READ_ROOM_CHAT, (messages) {
        print('----------YEAH ------------');
        print(messages);
        for (var msg in messages) {
          Message message = Message.fromMap(msg);
          String date =
              formatTime(DateTime.parse(message.date).millisecondsSinceEpoch);
          message.date = date;
          _messages.insert(0, message);
          _animatedListGlobalKey.currentState
              .insertItem(0, duration: Duration(milliseconds: 500));
        }
      });
      socketIO.emit(constants.EVENT_READ_ROOM_CHAT, [_data[1].toMap()['id']]);
      socketIO.on(constants.EVENT_SEND_ROOM_CHAT, (message) {
        print('-------- HERE -------------');
        print(message);
        Message msg = Message.fromMap(message);
        String date =
            formatTime(DateTime.parse(msg.date).millisecondsSinceEpoch);
        msg.date = date;
        print('---------DATE eeee--------------');
        print(msg);
        print(msg.toString());
        print('------------END-------------');
        _messages.insert(0, msg);
        _animatedListGlobalKey.currentState
            .insertItem(0, duration: Duration(milliseconds: 500));
      });
    }
    _isFirstTime = false;
  }

  void stopListeners() {
    if (_data[0] == ChatType.GENERAL_ROOM_CHAT) {
      socketIO.off(constants.EVENT_READ_GENERAL_ROOM_CHAT);
      socketIO.off(constants.EVENT_SEND_GENERAL_ROOM_CHAT);
    } else if (_data[0] == ChatType.PRIVATE_CHAT) {
      socketIO.off(constants.EVENT_READ_PRIVATE_CHAT);
      socketIO.off(constants.EVENT_SEND_PRIVATE_CHAT);
      socketIO.off(constants.EVENT_IS_TYPING);
    } else if (_data[0] == ChatType.ROOM_CHAT) {
      socketIO.off(constants.EVENT_READ_ROOM_CHAT);
      socketIO.off(constants.EVENT_SEND_ROOM_CHAT);
    }
  }

  Future textFieldOnChanged(value) async {
    if (_data[0] == ChatType.PRIVATE_CHAT) {
      socketIO.emit(constants.EVENT_IS_TYPING, [_data[1].toMap(), true]);
      await Future.delayed(Duration(seconds: 2));
      socketIO.emit(constants.EVENT_IS_TYPING, [_data[1].toMap(), false]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstTime) startListeners();
    _chatScreenNotifier =
        Provider.of<ChatScreenNotifier>(context, listen: false);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          _data[1] == null
                              ? 'R'
                              : _data[1].name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        width: 45,
                        height: 45,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                _data[0] == ChatType.PRIVATE_CHAT ? 30 : 18),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 6.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _data[0] == ChatType.GENERAL_ROOM_CHAT ||
                                    _data[0] == ChatType.ROOM_CHAT
                                ? Colors.white
                                : _data[1].status == 1 ? Colors.white : null,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 12,
                          width: 12,
                          child: Center(
                            child: Container(
                              decoration: _data[0] ==
                                          ChatType.GENERAL_ROOM_CHAT ||
                                      _data[0] == ChatType.ROOM_CHAT
                                  ? BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    )
                                  : _data[1].status == 1
                                      ? BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        )
                                      : null,
                              height: 8,
                              width: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Text(
                        _data[1] == null ? 'Room' : _data[1].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      _data[0] == ChatType.PRIVATE_CHAT
                          ? Selector<ChatScreenNotifier, bool>(
                              selector: (_, value) => value.isTyping,
                              builder: (_, isTyping, __) => Text(
                                isTyping
                                    ? "typing..."
                                    : _data[1].status == 0
                                        ? formatTime(DateTime.parse(
                                                _data[1].lastLogoutDate)
                                            .millisecondsSinceEpoch)
                                        : "Online",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                            )
                          : Text('Online',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              )),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.more_horiz,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: drawChatList(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {},
                    ),
                    contentPadding: EdgeInsets.all(0),
                    title: TextField(
                      controller: _textEditingController,
                      onChanged: textFieldOnChanged,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(style: BorderStyle.none, width: 0),
                          ),
                          hintText: "Type a message...",
                          hintStyle: TextStyle(fontSize: 13)),
                      maxLines: null,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        if (_textEditingController.text.isEmpty) return;
                        if (_data[0] == ChatType.GENERAL_ROOM_CHAT) {
                          Message message = Message(
                            sender: currentUser,
                            receiver: User(
                                id: null,
                                name: null,
                                date: null,
                                status: 0,
                                email: null,
                                lastLogoutDate: null),
                            content: _textEditingController.text,
                            date: DateTime.now().toString(),
                            room: Room(
                                name: null,
                                date: null,
                                id: null,
                                creator: User(
                                    id: null,
                                    name: null,
                                    date: null,
                                    status: 0,
                                    email: null,
                                    lastLogoutDate: null)),
                          );
                          socketIO.emit(constants.EVENT_SEND_GENERAL_ROOM_CHAT,
                              [message.toMap()]);
                        } else if (_data[0] == ChatType.PRIVATE_CHAT) {
                          Message message = Message(
                            sender: currentUser,
                            receiver: User(
                                name: _data[1].name,
                                id: _data[1].id,
                                date: null,
                                status: 0,
                                email: null,
                                lastLogoutDate: null),
                            content: _textEditingController.text,
                            date: DateTime.now().toString(),
                            room: Room(
                              name: null,
                              date: null,
                              id: null,
                              creator: User(
                                  id: null,
                                  name: null,
                                  date: null,
                                  status: 0,
                                  email: null,
                                  lastLogoutDate: null),
                            ),
                          );
                          socketIO.emit(constants.EVENT_SEND_PRIVATE_CHAT,
                              [message.toMap()]);
                        } else if (_data[0] == ChatType.ROOM_CHAT) {
                          Message message = Message(
                            sender: currentUser,
                            receiver: User(
                                id: null,
                                name: null,
                                date: null,
                                status: 0,
                                email: null,
                                lastLogoutDate: null),
                            content: _textEditingController.text,
                            date: DateTime.now().toString(),
                            room: _data[1],
                          );
                          socketIO.emit(constants.EVENT_SEND_ROOM_CHAT,
                              [message.toMap()]);
                        }
                        _textEditingController.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopListeners();
  }
}
