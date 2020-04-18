import 'dart:io';

import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import 'package:chat_app/constants.dart' as constants;
import 'package:chat_app/models/user.dart';
import 'package:chat_app/notifiers/non_shared_notifiers/login_screen_notifier.dart';
import 'package:chat_app/socket_obj.dart';
import 'package:chat_app/widgets/custom_fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginScreenNotifier(),
      child: LoginScreenBody(),
    );
  }
}

class LoginScreenBody extends StatefulWidget {
  @override
  _LoginScreenBodyState createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email;
  String _password;
  Animation<double> _animation;
  AnimationController _animationController;
  LoginScreenNotifier _loginScreenNotifier;

  void connect() async {
    socketIO = await SocketIOManager().createInstance(SocketOptions(url));
    socketIO.onConnect((value) {
      print('--------------- CONNECTED !! --------------');
      socketIO.emit('message', ['Hi from Client side !!']);
    });
    socketIO.on('message', (message) {
      print('------- message : $message -----------');
    });
    socketIO.connect();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation =
        Tween<double>(begin: 0.0, end: 3000.0).animate(_animationController);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('HomeScreen');
      }
    });
  }

  void save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      socketIO.emit(constants.EVENT_LOGIN_USER, [_email, _password]);
      socketIO.on(constants.EVENT_LOGIN_USER, (response) {
        print('--------------- Login response -----------');
        if (response[0]) {
          currentUser = User.fromMap(response[1]);
          socketIO.off(constants.EVENT_LOGIN_USER);
          _animationController.forward();
        } else {
          print('User not found !');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _loginScreenNotifier =
        Provider.of<LoginScreenNotifier>(context, listen: false);
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
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
                          borderRadius: BorderRadius.circular(16.0),
                        )
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Text(
                              'Login',
                              textAlign: Platform.isAndroid
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
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
                                helperText: 'write your account email here',
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
                            Selector<LoginScreenNotifier, bool>(
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
                                        'write your account password here',
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
                                          _loginScreenNotifier
                                                  .isVisiblePassword =
                                              !isVisiblePassword;
                                        })),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account?"),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, 'RegisterScreen');
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    )),
                              ],
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
