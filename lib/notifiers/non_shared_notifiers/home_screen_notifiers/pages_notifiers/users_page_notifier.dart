import 'package:flutter/foundation.dart';

class UsersPageNotifier with ChangeNotifier {
  int _results = 0;

  int get results => _results;

  set results(int value) {
    _results = value;
    notifyListeners();
  }
}
