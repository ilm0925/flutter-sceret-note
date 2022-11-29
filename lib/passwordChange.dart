import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Custom_Widgets.dart';
import 'key.dart';

class PasswordChage extends StatefulWidget {
  const PasswordChage({super.key});

  @override
  State<PasswordChage> createState() => _PasswordChageState();
}

class _PasswordChageState extends State<PasswordChage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? hashcode;

  @override
  void initState() {
    super.initState();
    checkExist();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    // currentKey = Provider.of<KeyProvider>(context, listen: false).getKey;

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
              if (hashcode != null) input("현재 비밀번호", currentPasswordController),
              input("새 비밀번호", newPasswordController),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  "변경하기",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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

  void submit() async {
    try {
      validatePassword();
    } catch (e) {
      passwordValidateError(context);
    }
    // 모든 글들을 decrypt => 새 비번으로 encrypt 반복
    String key = Provider.of<KeyProvider>(context, listen: false).getKey;
    List<String>? rules = await getRules();
    print(rules);
  }

  Future<String?> getHash() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString("password");
  }

  Future<List<String>?> getRules() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getStringList("rules");
  }

  void validatePassword() {
    if (hashcode == null) {
      return;
    }
  }

  void checkExist() async {
    hashcode = await getHash();
  }
}
