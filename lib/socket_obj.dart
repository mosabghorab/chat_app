import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:chat_app/models/user.dart';

//String url =
//    Platform.isAndroid ? 'http://10.0.2.2:3000/' : 'http://127.0.0.1:3000/';
String url = 'http://10.40.0.2:3000/';
//String url = 'http://10.2.65.87:3000/';
SocketIO socketIO;
User currentUser;
