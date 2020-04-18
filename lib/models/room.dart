import 'package:chat_app/models/user.dart';
import 'package:flutter/foundation.dart';

class Room {
  String _id;
  String _name;
  String _date;
  User _creator;

  Room(
      {@required String id,
      @required String name,
      @required User creator,
      @required String date}) {
    this._name = name;
    this._id = id;
    this._creator = creator;
    this._date = date;
  }

  get id => _id;

  set id(value) {
    _id = value;
  }

  User get creator => _creator;

  set creator(User value) {
    _creator = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  Map toMap() =>
      {'id': _id, 'creator': _creator.toMap(), 'name': _name, 'date': _date};

  static Room fromMap(Map room) => Room(
        id: room['id'],
        creator: User.fromMap(room['creator']),
        name: room['name'],
        date: room['date'],
      );
}
