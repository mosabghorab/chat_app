import 'package:flutter/foundation.dart';

class User {
  String _name, _email, _id, _date, _lastLogoutDate;
  int _status;

  User(
      {@required String name,
      @required String id,
      @required String date,
      @required String lastLogoutDate,
      @required String email,
      @required int status}) {
    this._id = id;
    this._name = name;
    this._date = date;
    this._lastLogoutDate = lastLogoutDate;
    this._email = email;
    this._status = status;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  get id => _id;

  set id(value) {
    _id = value;
  }

  get date => _date;

  set date(value) {
    _date = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get lastLogoutDate => _lastLogoutDate;

  set lastLogoutDate(value) {
    _lastLogoutDate = value;
  }

  Map toMap() => {
        'name': _name,
        'id': _id,
        'date': _date,
        'lastLogoutdate': _lastLogoutDate,
        'email': _email,
        'status': _status,
      };

  static User fromMap(Map user) => User(
      id: user['id'],
      name: user['name'],
      date: user['date'],
      email: user['email'],
      status: user['status'],
      lastLogoutDate: user['lastLogoutDate']);
}
