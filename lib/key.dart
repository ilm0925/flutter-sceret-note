import 'package:flutter/material.dart';

class KeyProvider with ChangeNotifier {
  late String _key = "1234567812345678";
  String get getKey => _key;

  void setKey(String password) {
    _key = convertToKey(password);
  }

  String convertToKey(String password) {
    while (password.length < 16) {
      password += password;
    }
    return password.substring(0, 16);
  }
}
