// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:flutter/material.dart';

AppBar Nav(bool isLogin, context) {
  if (isLogin) {
    return AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "비밀노트",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.security),
            tooltip: 'Hi!',
            onPressed: () => {Navigator.pushNamed(context, '/passwordChange')},
          ),
        ]);
  }
  return AppBar(
    backgroundColor: Colors.black,
    title: const Text(
      "비밀노트",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Text C_Text(String text, Color color, double size) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: size),
  );
}

OutlineInputBorder borderStyle() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white60),
    borderRadius: BorderRadius.circular(15),
  );
}
