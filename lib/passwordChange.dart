import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_note/crypto.dart';
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
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  String? hashcode;
  bool errorState = false;
  String errorMessage = "";

  bool encrypteProgressState = false;

  int maxProgress = 0;
  int currentProgress = 0;

  bool Changed = false;

  @override
  void initState() {
    super.initState();
    checkExist();
  }

  @override
  Widget build(BuildContext context) {
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
              Errormessage(),
              EncrypteProgress(),
              if (hashcode != null) input("현재 비밀번호", currentPasswordController),
              input("새 비밀번호", newPasswordController),
              const SizedBox(height: 10),
              ButtonWidget()
            ],
          ),
        ),
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
    SharedPreferences prefs = await _prefs;
    String key = Provider.of<KeyProvider>(context, listen: false).getKey;
    List<String>? rules = await getRules();
    Crypto crypto = Crypto(key);
    String newHash = crypto.encryptSHA256(newPasswordController.text);
    //prefs.setString("password", newHash);
    if (rules == null || rules.isEmpty) {
    } else {
      if (newPasswordController.text.length < 4) {
        setState(() {
          errorState = true;
          errorMessage = "새 비밀번호는 4자 이상이어야합니다";
        });
        Timer(const Duration(seconds: 5), () {
          setState(() {
            errorState = false;
          });
        });
        return;
      }
      List<dynamic> newRules = [];

      String newKey = Provider.of<KeyProvider>(context, listen: false)
          .convertToKey(newPasswordController.text);
      Crypto newCrypter = Crypto(newKey);
      for (int i = 0; i < rules.length; i++) {
        setState(() {
          encrypteProgressState = true;
          maxProgress = rules.length;
          currentProgress = i + 1;
        });
        List<dynamic> originalRule = json.decode(rules[i]);
        String decrypted = crypto.decryptBase64(originalRule[1]);
        String newEncryptedRule = newCrypter.encryptBase64(decrypted);
        originalRule[1] = newEncryptedRule;
        newRules.add(originalRule);
      }
      setState(() {
        Changed = true;
      });
    }
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

  Widget Errormessage() {
    if (errorState) {
      return Text(
        errorMessage,
        style: TextStyle(
            color: Colors.red[300], fontWeight: FontWeight.bold, fontSize: 20),
      );
    }
    return const SizedBox.shrink();
  }

  Widget EncrypteProgress() {
    if (encrypteProgressState) {
      return Column(
        children: [
          const Text(
            "새 비밀번호로 재 암호화 중..",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            "${currentProgress}/${maxProgress} 완료됨",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 5)
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget ButtonWidget() {
    if (Changed) {
      return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/");
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[400],
            padding: const EdgeInsets.all(14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: const Text(
          "홈으로 가기",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: submit,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            padding: const EdgeInsets.all(14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: const Text(
          "변경하기",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    }
  }
}
