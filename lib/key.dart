import 'package:flutter/material.dart';

class KeyProvider with ChangeNotifier {
  late String _key = "12345678123dd678";
  String get getKey => _key;

  void setKey(String password) {
    if (password.length >= 16) {
      _key = password.substring(0, 16);
      return;
    }
    while (password.length < 16) {
      password += password;
    }
    _key = password;
  }
}
