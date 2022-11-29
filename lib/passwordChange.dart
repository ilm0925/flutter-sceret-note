import 'package:flutter/material.dart';

import 'Custom_Widgets.dart';

class passwordChage extends StatefulWidget {
  const passwordChage({super.key});

  @override
  State<passwordChage> createState() => _passwordChageState();
}

class _passwordChageState extends State<passwordChage> {
  Padding input(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        cursorColor: Colors.red,
        obscureText: true,
        textAlign: TextAlign.center,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: borderStyle(),
            enabledBorder: borderStyle(),
            disabledBorder: borderStyle(),
            focusedBorder: borderStyle(),
            labelText: title,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelStyle: const TextStyle(color: Colors.white60, fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 188, 188, 188),
      appBar: Nav(false, context),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              input("현재 비밀번호", currentPasswordController),
              input("새 비밀번호", newPasswordController),
            ],
          ),
        ),
      ),
    );
  }
}
