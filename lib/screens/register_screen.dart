import 'dart:io';

import 'package:chat_app/constants.dart' as constants;
import 'package:chat_app/models/user.dart';
import 'package:chat_app/notifiers/non_shared_notifiers/register_screen_notifier.dart';
import 'package:chat_app/socket_obj.dart';
import 'package:chat_app/widgets/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterScreenNotifier(),
      child: RegisterScreenBody(),
    );
  }
}

class RegisterScreenBody extends StatefulWidget {
  @override
  _RegisterScreenBodyState createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _name, _email, _password;
  Animation<double> _animation;
  AnimationController _animationController;
  RegisterScreenNotifier _registerScreenNotifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation =
        Tween<double>(begin: 0.0, end: 3000.0).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            'HomeScreen', (Route<dynamic> route) => false);
      }
    });
  }

  void save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      currentUser = User(
          id: null,
          date: DateTime.now().toString(),
          name: _name,
          status: 1,
          lastLogoutDate: null,
          email: _email);
      socketIO.emit(
          constants.EVENT_REGISTER_USER, [currentUser.toMap(), _password]);
      socketIO.on(constants.EVENT_REGISTER_USER, (response) {
        print('--------------- RESPONSE -----------');
        currentUser = User.fromMap(response);
        socketIO.off(constants.EVENT_REGISTER_USER);
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _registerScreenNotifier =
        Provider.of<RegisterScreenNotifier>(context, listen: false);
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Register'),
          ),
          body: Container(
            child: Center(
                child: CustomFadeAnimation(
              1,
              Container(
                height: Platform.isAndroid
                    ? MediaQuery.of(context).size.height * 0.6
                    : MediaQuery.of(context).size.height * 0.6,
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 10,
                  shape: Platform.isIOS
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 36, horizontal: 16),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Text(
                              'Register',
                              textAlign: Platform.isAndroid
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) return 'Name is requblue';
                                return null;
                              },
                              onSaved: (value) {
                                _name = value;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Enter a name',
                                  helperText:
                                      'This is your username in the app',
                                  prefixIcon: Platform.isAndroid
                                      ? null
                                      : Icon(Icons.person),
                                  contentPadding: EdgeInsets.all(
                                      Platform.isAndroid ? 8 : 20),
                                  icon: Platform.isAndroid
                                      ? Icon(Icons.person)
                                      : null,
                                  border: Platform.isAndroid
                                      ? null
                                      : OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)),
                                          borderSide: BorderSide())),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) return 'Email is requblue';
                                return null;
                              },
                              onSaved: (value) {
                                _email = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter email address',
                                helperText:
                                    'This email will be your email in the app',
                                prefixIcon: Platform.isAndroid
                                    ? null
                                    : Icon(Icons.email),
                                contentPadding:
                                    EdgeInsets.all(Platform.isAndroid ? 8 : 20),
                                icon: Platform.isAndroid
                                    ? Icon(Icons.email)
                                    : null,
                                border: Platform.isAndroid
                                    ? null
                                    : OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        borderSide: BorderSide(),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Selector<RegisterScreenNotifier, bool>(
                              selector: (_, value) => value.isVisiblePassword,
                              builder: (_, isVisiblePassword, __) =>
                                  TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'password is requblue';
                                  return null;
                                },
                                onSaved: (value) {
                                  _password = value;
                                },
                                obscureText: !isVisiblePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter password',
                                  helperText:
                                      'This password your account password',
                                  prefixIcon: Platform.isAndroid
                                      ? null
                                      : Icon(Icons.lock),
                                  contentPadding: EdgeInsets.all(
                                      Platform.isAndroid ? 8 : 20),
                                  icon: Platform.isAndroid
                                      ? Icon(Icons.lock)
                                      : null,
                                  border: Platform.isAndroid
                                      ? null
                                      : OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)),
                                          borderSide: BorderSide(),
                                        ),
                                  suffixIcon: IconButton(
                                      icon: Icon(isVisiblePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        _registerScreenNotifier
                                                .isVisiblePassword =
                                            !isVisiblePassword;
                                      }),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ),
          floatingActionButton: CustomFadeAnimation(
            2,
            FloatingActionButton(
              onPressed: save,
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
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
}
