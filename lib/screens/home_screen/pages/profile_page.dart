import 'package:chat_app/notifiers/shared_notifiers/app_notifiers/theme_notifier.dart';
import 'package:chat_app/socket_obj.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeNotifier _themeNotifier;

  @override
  Widget build(BuildContext context) {
    _themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      currentUser.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(80),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 30.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 18,
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              height: 10,
            ),
            Selector<ThemeNotifier, bool>(
              selector: (_, value) => value.isDark,
              builder: (_, isDark, __) => ListTile(
                leading: Icon(
                  Icons.brightness_2,
                ),
                title: Text('Theme'),
                subtitle: Text(isDark ? 'Dark' : 'Light'),
                trailing: Switch.adaptive(
                  value: isDark,
                  onChanged: (value) {
                    _themeNotifier.isDark = !isDark;
                  },
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Name'),
              subtitle: Text(currentUser.name),
              trailing: Icon(Icons.edit),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(currentUser.email),
              trailing: Icon(Icons.edit),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text('Registeration time'),
              subtitle: Text(currentUser.date),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.transfer_within_a_station),
              title: Text('Status'),
              subtitle: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(currentUser.status == 0 ? 'Offline' : 'Online'),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(Icons.edit),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
            )
          ],
        ));
  }
}
