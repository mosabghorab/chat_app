import 'package:chat_app/models/room.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/foundation.dart';

class Message {
  String _content;
  String _date;
  User _sender, _receiver;
  Room _room;

  Message(
      {@required String content,
      @required String date,
      @required User sender,
      @required User receiver,
      @required Room room}) {
    this._receiver = receiver;
    this._room = room;
    this._sender = sender;
    this._content = content;
    this._date = date;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  User get sender => _sender;

  set sender(User value) {
    _sender = value;
  }

  get receiver => _receiver;

  set receiver(value) {
    _receiver = value;
  }

  Room get room => _room;

  set room(Room value) {
    _room = value;
  }

  Map toMap() => {
        'content': _content,
        'sender': _sender.toMap(),
        'receiver': _receiver.toMap(),
        'room': _room.toMap(),
        'date': _date,
      };

  static Message fromMap(Map message) => Message(
      content: message['content'],
      receiver: User.fromMap(message['receiver']),
      sender: User.fromMap(message['sender']),
      room: Room.fromMap(message['room']),
      date: message['date']);
}
