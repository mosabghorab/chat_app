import 'package:chat_app/constants.dart' as constants;
import 'package:chat_app/functions.dart' as functions;
import 'package:chat_app/models/room.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/chat_item.dart';
import 'package:flutter/material.dart';

import '../../../../../socket_obj.dart';

class JoinedRoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JoinedRoomsPageBody();
  }
}

class JoinedRoomsPageBody extends StatefulWidget {
  @override
  _JoinedRoomsPageBodyState createState() => _JoinedRoomsPageBodyState();
}

class _JoinedRoomsPageBodyState extends State<JoinedRoomsPageBody>
    with SingleTickerProviderStateMixin {
  List<Room> _joinedRooms = [];
  GlobalKey<AnimatedListState> _animatedListGlobalKey = GlobalKey();

  Widget drawRoomsListItem(Animation anm, Room room) => SizeTransition(
        sizeFactor: anm,
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: Theme.of(context).brightness == Brightness.light
              ? BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200], spreadRadius: 5, blurRadius: 3),
                  BoxShadow(
                      color: Colors.grey[200], spreadRadius: 5, blurRadius: 3),
                  BoxShadow(
                      color: Colors.grey[200], spreadRadius: 5, blurRadius: 3),
                  BoxShadow(
                      color: Colors.grey[200], spreadRadius: 5, blurRadius: 3),
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
              dp: room.name.substring(0, 1).toUpperCase(),
              name: room.name,
              msg: 'hi,there',
              isOnline: true,
              onTap: () {
                Navigator.pushNamed(context, 'ChatScreen',
                    arguments: [ChatType.ROOM_CHAT, room]);
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        ),
      );

  Widget drawRoomsList() => AnimatedList(
      key: _animatedListGlobalKey,
      initialItemCount: _joinedRooms.length,
      itemBuilder: (context, index, anm) =>
          drawRoomsListItem(anm, _joinedRooms[index]));

  void startListeners() {
    socketIO.on(constants.EVENT_JOIN_ROOM, (data) {
      print('--------------  join room -------------------');
      User userObj = User.fromMap(data[0]);
      Room roomObj = Room.fromMap(data[1]);
      if (currentUser.id == userObj.id) {
        _joinedRooms.insert(0, roomObj);
        _animatedListGlobalKey.currentState
            .insertItem(0, duration: Duration(milliseconds: 500));
        functions.showMessage(
            'Room Joining',
            '${roomObj.creator.name} added you to his room "${roomObj.name}"',
            NotificationMessageType.SUCCESS);
      } else if (currentUser.id != roomObj.creator.id) {
        functions.showMessage(
            'New user joind',
            '${userObj.name} has joined to the ${roomObj.name} room',
            NotificationMessageType.SUCCESS);
      }
    });
    socketIO.on(constants.EVENT_LEAVE_ROOM, (data) {
      print('-------------- leave room -------------------');
      User userObj = User.fromMap(data[0]);
      Room roomObj = Room.fromMap(data[1]);
      print('------ yeah ---------');
      if (currentUser.id == userObj.id) {
        int roomIndex;
        for (int i = 0; i < _joinedRooms.length; i++) {
          if (_joinedRooms[i].id == roomObj.id) {
            roomIndex = i;
            break;
          }
        }
        Room removedRoom = _joinedRooms.removeAt(roomIndex);
        _animatedListGlobalKey.currentState.removeItem(roomIndex,
            (context, anm) {
          return drawRoomsListItem(anm, removedRoom);
        }, duration: Duration(milliseconds: 500));
        functions.showMessage(
            'Room Leaving',
            '${roomObj.creator.name} deleted you from his room "${roomObj.name}"',
            NotificationMessageType.FAILED);
      } else if (currentUser.id != roomObj.creator.id) {
        functions.showMessage(
            'user leaved',
            '${userObj.name} has leaved from the ${roomObj.name} room',
            NotificationMessageType.FAILED);
      }
    });
    socketIO.emit(constants.EVENT_READ_JOINED_ROOMS, []);
    socketIO.on(constants.EVENT_READ_JOINED_ROOMS, (rooms) {
      print('--------------HERE read join-------------------');
      for (var r in rooms) {
        Room room = Room.fromMap(r);
        _joinedRooms.insert(0, room);
        _animatedListGlobalKey.currentState
            .insertItem(0, duration: Duration(milliseconds: 300));
      }
    });
  }

  void stopListeners() {
    socketIO.off(constants.EVENT_READ_JOINED_ROOMS);
    socketIO.off(constants.EVENT_JOIN_ROOM);
    socketIO.off(constants.EVENT_LEAVE_ROOM);
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
