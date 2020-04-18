import 'dart:io';

import 'package:chat_app/widgets/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation =
        Tween<double>(begin: 0.0, end: 3000.0).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, 'LoginScreen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFadeAnimation(
        2,
        FloatingActionButton(
          onPressed: () {
            _animationController.forward();
          },
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          isExtended: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Platform.isAndroid
                  ? Icons.arrow_forward
                  : Icons.arrow_forward_ios),
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 1,
                  height: 1,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle),
                ),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomFadeAnimation(
                0.5,
                Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
              CustomFadeAnimation(
                1,
                Text(
                  ' CHAT US',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
}
