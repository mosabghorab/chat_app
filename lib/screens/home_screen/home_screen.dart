import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:chat_app/constants.dart' as constants;
import 'package:chat_app/models//room.dart';
import 'package:chat_app/notifiers/non_shared_notifiers/home_screen_notifiers/home_screen_notifier.dart';
import 'package:chat_app/screens/home_screen/pages/profile_page.dart';
import 'package:chat_app/screens/home_screen/pages/rooms_page/rooms_page.dart';
import 'package:chat_app/screens/home_screen/pages/users_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../socket_obj.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenNotifier(),
      child: HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  PageController _pageController = PageController();
  HomeScreenNotifier _homeScreenNotifier;
  GlobalKey<FormState> _createGroupFormKey = GlobalKey();
  String _name;

  Widget createRoomDialog() => AlertDialog(
        content: Container(
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          child: Form(
              key: _createGroupFormKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (value) => _name = value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please fill name field';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: Platform.isIOS
                            ? OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )
                            : null,
                        icon: Platform.isIOS ? null : Icon(LineIcons.group),
                        prefixIcon:
                            Platform.isIOS ? Icon(LineIcons.group) : null,
                        hintText: 'Enter room name',
                        helperText: 'Type the room name here',
                        labelText: 'Name'),
                  ),
                ],
              )),
        ),
        elevation: 10,
        title: Text(
          'New Room',
          textAlign: Platform.isAndroid ? TextAlign.left : TextAlign.center,
          style: TextStyle(
              color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        shape: Platform.isIOS
            ? OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none),
                borderRadius: BorderRadius.all(Radius.circular(15)))
            : null,
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL')),
          FlatButton(
              onPressed: () {
                if (_createGroupFormKey.currentState.validate()) {
                  Navigator.pop(context);
                  _createGroupFormKey.currentState.save();
                  Room room = Room(
                      id: null,
                      name: _name,
                      creator: currentUser,
                      date: DateTime.now().toString());
                  socketIO.emit(constants.EVENT_CREATE_ROOM, [room.toMap()]);
                }
              },
              child: Text('CREATE')),
        ],
      );

  @override
  Widget build(BuildContext context) {
    _homeScreenNotifier =
        Provider.of<HomeScreenNotifier>(context, listen: false);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (value) {
                print(value);
                if (value != 0) return;
                socketIO.emit(
                    constants.EVENT_LOGOUT_USER, [DateTime.now().toString()]);
                socketIO.onDisconnect((v) {
                  print('-------------------Diconnect-------------');
                  currentUser = null;
                  Navigator.pushReplacementNamed(context, 'LoginScreen');
                });
              },
              itemBuilder: (_) => ['Logout'].map((value) {
                return PopupMenuItem(
                  child: Text(value),
                  value: 0,
                );
              }).toList(),
            )
          ],
          title: Selector<HomeScreenNotifier, int>(
              selector: (_, value) => value.pageIndex,
              builder: (_, pageIndex, __) => Text(pageIndex == 0
                  ? 'Home'
                  : pageIndex == 1 ? 'Rooms' : 'Profile')),
        ),
        floatingActionButton: Selector<HomeScreenNotifier, int>(
          selector: (_, value) => value.pageIndex,
          builder: (_, pageIndex, __) => pageIndex == 1
              ? FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context, builder: (_) => createRoomDialog());
                  },
                  child: Icon(LineIcons.plus),
                )
              : Container(),
        ),
        bottomNavigationBar: Selector<HomeScreenNotifier, int>(
            selector: (_, value) => value.pageIndex,
            builder: (_, pageIndex, __) => Platform.isIOS
                ? BottomNavyBar(
                    selectedIndex: pageIndex,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    itemCornerRadius: 18,
                    showElevation:
                        true, // use this to remove appBar's elevation
                    onItemSelected: (pageIndex) {
                      _pageController.animateToPage(pageIndex,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    },
                    items: [
                      BottomNavyBarItem(
                          icon: Icon(LineIcons.home),
                          title: Text('Home'),
                          background: Colors.blueAccent,
                          inactiveColor: Colors.grey,
                          activeColor: Colors.white),
                      BottomNavyBarItem(
                          icon: Icon(LineIcons.group),
                          title: Text(
                            'Rooms',
                            style: TextStyle(color: Colors.white),
                          ),
                          background: Colors.blueAccent,
                          inactiveColor: Colors.grey,
                          activeColor: Colors.white),
                      BottomNavyBarItem(
                          icon: Icon(LineIcons.user),
                          title: Text('Profile '),
                          background: Colors.blueAccent,
                          inactiveColor: Colors.grey,
                          activeColor: Colors.white),
                    ],
                  )
                : BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: pageIndex,
                    onTap: (pageIndex) {
                      _pageController.animateToPage(pageIndex,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(LineIcons.home),
                        title: Text('Home'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(LineIcons.users),
                        title: Text('Rooms'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(LineIcons.user),
                        title: Text('Profile'),
                      ),
                    ],
                  )),
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            UsersPage(),
            RoomsPage(),
            ProfilePage(),
          ],
          onPageChanged: (pageIndex) {
            _homeScreenNotifier.pageIndex = pageIndex;
          },
        ),
      ),
    );
  }
}
