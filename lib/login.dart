import 'package:flutter/material.dart';
import 'package:secret_note/Custom_Widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 188, 188, 188),
      appBar: Nav(false),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                cursorColor: Colors.red,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                onSubmitted: (String text) {
                  passwordController.clear();
                  Navigator.pushNamed(context, '/note');
                },
                controller: passwordController,
                decoration: InputDecoration(
                    border: borderStyle(),
                    enabledBorder: borderStyle(),
                    disabledBorder: borderStyle(),
                    focusedBorder: borderStyle(),
                    labelText: '비밀번호',
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    labelStyle:
                        const TextStyle(color: Colors.white60, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder borderStyle() {
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white60));
  }
}
