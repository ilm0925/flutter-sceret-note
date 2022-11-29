import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_note/Custom_Widgets.dart';
import 'package:secret_note/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'key.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
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
              TextField(
                cursorColor: Colors.red,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                onSubmitted: submit,
                controller: passwordController,
                decoration: InputDecoration(
                    border: borderStyle(),
                    enabledBorder: borderStyle(),
                    disabledBorder: borderStyle(),
                    focusedBorder: borderStyle(),
                    labelText: "비밀번호 입력",
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

  void init() async {
    SharedPreferences prefs = await _prefs;
    String? hash = prefs.getString("password");
    if (hash == null) {
      Navigator.pushNamed(context, '/note');
    }
  }

  void submit(String text) async {
    passwordController.clear();
    SharedPreferences prefs = await _prefs;
    String? hash = prefs.getString("password");
    if (hash == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/note');
    } else {
      Crypto crypto = Crypto(hash, 16);
      if (crypto.encryptSHA256(text) == hash) {
        // print(Provider.of<KeyProvider>(context).getKey);
        Provider.of<KeyProvider>(context, listen: false).setKey(text);
        Navigator.pushNamed(context, '/note');
      } else {
        passwordValidateError(context);
      }
    }
  }
}
