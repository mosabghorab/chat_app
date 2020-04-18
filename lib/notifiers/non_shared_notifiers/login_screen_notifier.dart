import 'package:flutter/foundation.dart';

class LoginScreenNotifier with ChangeNotifier {
  bool _isVisiblePassword = false;

  bool get isVisiblePassword => _isVisiblePassword;

  set isVisiblePassword(bool value) {
    _isVisiblePassword = value;
    notifyListeners();
  }
}
