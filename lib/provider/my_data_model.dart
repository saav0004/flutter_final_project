import 'package:flutter/material.dart';

class MyDataModel extends ChangeNotifier {
  // default values
  String _deviceId = '123456789';
  String _sessionId = '123456789';
  String _code = '123456789';

  // getters
  String get deviceId => _deviceId;
  String get sessionId => _sessionId;
  String get code => _code;

  // setters
  set setDeviceId(String deviceId) {
    _deviceId = deviceId;
    notifyListeners();
  }

  set setSessionId(String sessionId) {
    _sessionId = sessionId;
    notifyListeners();
  }

  set setCode(String code) {
    _code = code;
    notifyListeners();
  }
}
