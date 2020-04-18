import 'package:bot_toast/bot_toast.dart';
import 'package:chat_app/notifiers/shared_notifiers/app_notifiers/theme_notifier.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/home_screen/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: ChangeNotifierProvider(
        create: (context) => ThemeNotifier(),
        child: MyAppBody(),
      ),
    );
  }
}

class MyAppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ThemeNotifier, bool>(
      selector: (_, value) => value.isDark,
      builder: (_, isDark, __) => MaterialApp(
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'Flutter Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          fontFamily: 'NanumGothic',
        ),
        darkTheme: ThemeData(
          backgroundColor: Colors.black12,
          brightness: Brightness.dark,
          fontFamily: 'NanumGothic',
        ),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        routes: {
          'RegisterScreen': (BuildContext context) => RegisterScreen(),
          'LoginScreen': (BuildContext context) => LoginScreen(),
          'ChatScreen': (BuildContext context) => ChatScreen(),
          'HomeScreen': (BuildContext context) => HomeScreen(),
          'SplashScreen': (BuildContext context) => SplashScreen(),
        },
        initialRoute: 'SplashScreen',
      ),
    );
  }
}
