// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:flutter/material.dart';

AppBar Nav() {
  return AppBar(
        backgroundColor: Colors.black,
        title: const Text("비밀노트", style: TextStyle(fontWeight: FontWeight.bold),),
      );
}

@override
Text C_Text(String text , Color color , double size){
  return Text(text , style: TextStyle(color: color ,fontSize: size),);
}