import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:chat_app/screens/home_screen/pages/rooms_page/pages/created_rooms_page.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/chat_item.dart';
import 'package:flutter/material.dart';

import 'pages/joined_rooms_page.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoomsPageBody();
  }
}

class RoomsPageBody extends StatefulWidget {
  @override
  _RoomsPageBodyState createState() => _RoomsPageBodyState();
}

class _RoomsPageBodyState extends State<RoomsPageBody>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(12),
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
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).backgroundColor
                    : Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
            child: ChatItem(
              dp: 'R',
              isRoom: true,
              name: 'General Room',
              msg: 'hi,there',
              isOnline: true,
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
                size: 20,
              ),
              onTap: () {
                Navigator.pushNamed(context, 'ChatScreen',
                    arguments: [ChatType.GENERAL_ROOM_CHAT, null]);
              },
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(18),
            alignment: Alignment.centerLeft,
            child: Platform.isIOS
                ? TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: new BubbleTabIndicator(
                      indicatorColor: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      tabBarIndicatorSize: TabBarIndicatorSize.label,
                    ),
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          'Created',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Joined',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                : TabBar(
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    labelColor: Colors.blue,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          'Created',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Joined',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: CreatedRoomsPage(),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: JoinedRoomsPage(),
            )
          ],
        ))
      ],
    );
  }
}
