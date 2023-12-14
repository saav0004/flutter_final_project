import 'package:flutter/material.dart';

class MyDataModel extends ChangeNotifier {
  // default values
  String _deviceId = '';
  String _sessionId = '';
  String _code = '';
  bool _isMatch = false;

  // getters
  String get deviceId => _deviceId;
  String get sessionId => _sessionId;
  String get code => _code;
  bool get isMatch => _isMatch;

  // setters
  void setDeviceId(String deviceId) {
    _deviceId = deviceId;
    notifyListeners();
  }

  void setSessionId(String sessionId) {
    _sessionId = sessionId;
    notifyListeners();
  }

  void setCode(String code) {
    _code = code;
    notifyListeners();
  }

  void setIsMatch(bool isMatch) {
    _isMatch = isMatch;
    notifyListeners();
  }
}
