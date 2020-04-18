import 'package:flutter/foundation.dart';

class RegisterScreenNotifier with ChangeNotifier {
  bool _isVisiblePassword = false;

  bool get isVisiblePassword => _isVisiblePassword;

  set isVisiblePassword(bool value) {
    _isVisiblePassword = value;
    notifyListeners();
  }
}
