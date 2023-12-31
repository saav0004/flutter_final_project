import 'package:flutter/material.dart';

class MyDataModel extends ChangeNotifier {
  // default values
  String _deviceId = '';
  String _sessionId = '';
  String _code = '';

  // getters
  String get deviceId => _deviceId;
  String get sessionId => _sessionId;
  String get code => _code;

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
}
