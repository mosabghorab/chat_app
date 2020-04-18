import 'package:flutter/foundation.dart';

class ChatScreenNotifier with ChangeNotifier {
  bool _isTyping = false;

  bool get isTyping => _isTyping;

  set isTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }
}
