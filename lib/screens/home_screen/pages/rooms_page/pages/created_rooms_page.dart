import 'dart:io';

import 'package:chat_app/constants.dart' as constants;
import 'package:chat_app/models/room.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../../socket_obj.dart';

class CreatedRoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreatedRoomsPageBody();
  }
}

class CreatedRoomsPageBody extends StatefulWidget {
  @override
  _CreatedRoomsPageBodyState createState() => _CreatedRoomsPageBodyState();
}

class _CreatedRoomsPageBodyState extends State<CreatedRoomsPageBody>
    with SingleTickerProviderStateMixin {
  List<Room> _createdRooms = [];
  List<User> _users = [];
  GlobalKey<AnimatedListState> _animatedListGlobalKey = GlobalKey();

  Widget buildUsersList(Room room, int flag) => ListView.separated(
      itemBuilder: (_, index) => ChatItem(
          isRoom: true,
          dp: _users[index].name.substring(0, 1).toUpperCase(),
          name: _users[index].name,
          msg: 'hi there',
          isOnline: true,
          onTap: () {},
          trailing: IconButton(
              icon: flag == 0
                  ? Icon(Icons.add, color: Colors.blue)
                  : Icon(Icons.minimize, color: Colors.red),
              onPressed: () {
                if (flag == 0) {
                  socketIO.emit(constants.EVENT_JOIN_ROOM,
                      [_users[index].toMap(), room.toMap()]);
                } else {
                  socketIO.emit(constants.EVENT_LEAVE_ROOM,
                      [_users[index].toMap(), room.toMap()]);
                }
              })),
      separatorBuilder: (_, index) => Divider(
            thickness: 0.5,
          ),
      itemCount: _users.length);

  Widget addUsersToRoomDialog(Room room) => AlertDialog(
        title: Text(
          'Join ${room.name}',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 10,
        shape: Platform.isIOS
            ? OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none),
                borderRadius: BorderRadius.all(Radius.circular(15)))
            : null,
        content: Container(
          width: 300,
          height: 400,
          child: buildUsersList(room, 0),
        ),
      );

  Widget deleteUsersFromRoomDialog(Room room) => AlertDialog(
        title: Text(
          'Join ${room.name}',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 10,
        shape: Platform.isIOS
            ? OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none),
                borderRadius: BorderRadius.all(Radius.circular(15)))
            : null,
        content: Container(
          width: 300,
          height: 400,
          child: buildUsersList(room, 1),
        ),
      );

  Widget drawRoomsList() => AnimatedList(
        key: _animatedListGlobalKey,
        initialItemCount: _createdRooms.length,
        itemBuilder: (context, index, anm) => SizeTransition(
            sizeFactor: anm,
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: Theme.of(context).brightness == Brightness.light
                  ? BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          spreadRadius: 5,
                          blurRadius: 3),
                      BoxShadow(
                          color: Colors.grey[200],
                          spreadRadius: 5,
                          blurRadius: 3),
                      BoxShadow(
                          color: Colors.grey[200],
                          spreadRadius: 5,
                          blurRadius: 3),
                      BoxShadow(
                          color: Colors.grey[200],
                          spreadRadius: 5,
                          blurRadius: 3),
                    ])
                  : null,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).backgroundColor
                        : Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    )),
                child: ChatItem(
                  isRoom: true,
                  dp: _createdRooms[index].name.substring(0, 1).toUpperCase(),
                  name: _createdRooms[index].name,
                  msg: 'hi,there',
                  isOnline: true,
                  onTap: () {
                    Navigator.pushNamed(context, 'ChatScreen',
                        arguments: [ChatType.ROOM_CHAT, _createdRooms[index]]);
                  },
                  trailing: _createdRooms[index].creator.id == currentUser.id
                      ? Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    LineIcons.user_plus,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => addUsersToRoomDialog(
                                            _createdRooms[index]));
                                  }),
                              IconButton(
                                  icon: Icon(
                                    LineIcons.minus_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            deleteUsersFromRoomDialog(
                                                _createdRooms[index]));
                                  }),
                            ],
                          ),
                        )
                      : Icon(Icons.arrow_forward_ios),
                ),
              ),
            )),
      );

  void startListeners() {
    socketIO.emit(constants.EVENT_READ_USERS, []);
    socketIO.on(constants.EVENT_READ_USERS, (users) {
      for (var user in users) {
        _users.add(User.fromMap(user));
      }
    });
    socketIO.on(constants.EVENT_CREATE_ROOM, (room) {
      Room newRoom = Room.fromMap(room);
      _createdRooms.insert(0, newRoom);
      _animatedListGlobalKey.currentState
          .insertItem(0, duration: Duration(milliseconds: 500));
    });
    socketIO.emit(constants.EVENT_READ_CREATED_ROOMS, []);
    socketIO.on(constants.EVENT_READ_CREATED_ROOMS, (rooms) {
      for (var r in rooms) {
        Room room = Room.fromMap(r);
        room.creator = currentUser;
        _createdRooms.insert(0, room);
        _animatedListGlobalKey.currentState
            .insertItem(0, duration: Duration(milliseconds: 300));
      }
    });
  }

  void stopListeners() {
    socketIO.off(constants.EVENT_READ_USERS);
    socketIO.off(constants.EVENT_READ_CREATED_ROOMS);
    socketIO.off(constants.EVENT_CREATE_ROOM);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: drawRoomsList(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopListeners();
  }
}
