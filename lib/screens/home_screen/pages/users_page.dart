import 'package:chat_app/constants.dart' as constants;
import 'package:chat_app/functions.dart' as functions;
import 'package:chat_app/models/user.dart';
import 'package:chat_app/notifiers/non_shared_notifiers/home_screen_notifiers/pages_notifiers/users_page_notifier.dart';
import 'package:chat_app/socket_obj.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UsersPageNotifier(),
      child: UsersPageBody(),
    );
  }
}

class UsersPageBody extends StatefulWidget {
  @override
  _UsersPageBodyState createState() => _UsersPageBodyState();
}

class _UsersPageBodyState extends State<UsersPageBody> {
  List<User> _users = [];
  GlobalKey<AnimatedListState> _animatedListGlobalKey = GlobalKey();
  UsersPageNotifier _usersPageNotifier;

  Widget drawUserListItem(Animation anm, User user) => SizeTransition(
        sizeFactor: anm,
        child: Container(
          margin: EdgeInsets.all(6),
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
              isRoom: false,
              dp: user.name.substring(0, 1).toUpperCase(),
              name: user.name,
              msg: 'hi,there',
              isOnline: user.status == 0 ? false : true,
              onTap: () {
                Navigator.pushNamed(context, 'ChatScreen',
                    arguments: [ChatType.PRIVATE_CHAT, user]);
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

  Widget drawUsersList() => AnimatedList(
      key: _animatedListGlobalKey,
      initialItemCount: _users.length,
      itemBuilder: (context, index, anm) =>
          drawUserListItem(anm, _users[index]));

  // method for start listeners on this page >>
  void startListeners() {
    socketIO.on(constants.EVENT_REGISTER_USER, (user) {
      User newUser = User.fromMap(user);
      _users.insert(0, newUser);
      functions.showMessage('New user', 'user ${newUser.name} registed now',
          NotificationMessageType.SUCCESS);
      _animatedListGlobalKey.currentState
          .insertItem(0, duration: Duration(milliseconds: 500));
      _usersPageNotifier.results = _users.length;
    });
    socketIO.on(constants.EVENT_LOGOUT_USER, (data) {
      if (data[0] == currentUser.id) {
        socketIO.emit(constants.EVENT_DISCONNECT, []);
      } else {
        int userIndex;
        for (int i = 0; i < _users.length; i++) {
          print(_users[i].id);
          print(data[0]);
          if (_users[i].id == data[0]) {
            userIndex = i;
            break;
          }
        }
        User removedUser = _users.removeAt(userIndex);
        _animatedListGlobalKey.currentState.removeItem(userIndex,
            (context, anm) {
          return drawUserListItem(anm, removedUser);
        }, duration: Duration(seconds: 0));
        removedUser.status = 0;
        removedUser.lastLogoutDate = data[1];
        _users.insert(userIndex, removedUser);
        _animatedListGlobalKey.currentState
            .insertItem(userIndex, duration: Duration(seconds: 0));
      }
    });
    socketIO.on(constants.EVENT_LOGIN_USER, (data) {
      int userIndex;
      User newUser = User.fromMap(data[1]);
      if (currentUser.id != newUser.id) {
        for (int i = 0; i < _users.length; i++) {
          if (_users[i].name == newUser.name) {
            _users[i].id = newUser.id;
            userIndex = i;
            break;
          }
        }
        User removedUser = _users.removeAt(userIndex);
        _animatedListGlobalKey.currentState.removeItem(userIndex,
            (context, anm) {
          return drawUserListItem(anm, removedUser);
        }, duration: Duration(seconds: 0));
        removedUser.status = 1;
        _users.insert(userIndex, removedUser);
        _animatedListGlobalKey.currentState
            .insertItem(userIndex, duration: Duration(seconds: 0));
      }
    });
    socketIO.emit(constants.EVENT_READ_USERS, []);
    socketIO.on(constants.EVENT_READ_USERS, (users) {
      for (var user in users) {
        User newUser = User.fromMap(user);
        _users.insert(0, newUser);
        _animatedListGlobalKey.currentState
            .insertItem(0, duration: Duration(milliseconds: 500));
      }
      _usersPageNotifier.results = _users.length;
    });
  }

  // method for stop listeners on this page >>
  void stopListeners() {
    socketIO.off(constants.EVENT_READ_USERS);
    socketIO.off(constants.EVENT_REGISTER_USER);
    socketIO.off(constants.EVENT_LOGIN_USER);
    socketIO.off(constants.EVENT_LOGOUT_USER);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startListeners();
  }

  @override
  Widget build(BuildContext context) {
    _usersPageNotifier = Provider.of<UsersPageNotifier>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black12
                      : Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              alignment: Alignment.centerLeft,
              child: Selector<UsersPageNotifier, int>(
                selector: (_, value) => value.results,
                builder: (_, results, __) => Text(
                  'Results ($results)',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              )),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: drawUsersList(),
          ),
        ],
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
