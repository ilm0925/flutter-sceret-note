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

void passwordValidateError(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black45,
          content: const Text("비밀번호 틀림",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18)),
          actions: <Widget>[
            TextButton(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
