import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:secret_note/Rules.dart';
import 'package:secret_note/test.dart';
import 'Custom_Widgets.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String hint = "규칙 입력";
  String inputRules = "";

  List<RulesMap> Rules = [
    RulesMap(DateTime.now(), "규칙 1", 5),
    RulesMap(DateTime.now(), "규칙 2", 5),
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 4", 5),
    RulesMap(DateTime.now(), "규칙 5", 5),
    RulesMap(DateTime.now(), "규칙 6", 5),
    RulesMap(DateTime.now(), "규칙 10", 5),
  ];

  double deviceWidth = 300;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 188, 188, 188),
      appBar: Nav(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: SizedBox(
                width: deviceWidth - 50,
                child: ruleInput(borderStyles),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            line(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "이건 꼭 지키기",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 30),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ListView.builder(
                    itemCount: Rules.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (c, i) {
                      return Column(
                        children: [ruleBox(Rules[i]), line()],
                      );
                    })
              ],
            )
          ],
        ),
      ),
    );
  }

  OutlineInputBorder borderStyles() {
    return OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(20));
  }

  Container line() {
    return Container(
      width: deviceWidth,
      height: 0.2,
      color: const Color.fromARGB(255, 100, 100, 100),
    );
  }

  InkWell ruleBox(RulesMap rules) {
    return InkWell(
      onTap: () {
        detail(rules.description);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            //<-- SEE HERE
            side: const BorderSide(
              color: Color.fromARGB(255, 188, 188, 188),
            ),
            borderRadius: BorderRadius.circular(20)),
        color: const Color.fromARGB(31, 67, 67, 67),
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: deviceWidth - 50,
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: null,
              text: TextSpan(
                text: rules.description,
                style: const TextStyle(
                  color: Color.fromARGB(255, 210, 210, 210),
                  height: 1.4,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void detail(String rule) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black45,
            content: Text(rule,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
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

  TextField ruleInput(OutlineInputBorder Function() borderStyles) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color.fromARGB(31, 255, 255, 255),
        disabledBorder: borderStyles(),
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 180, 180, 180),
            fontWeight: FontWeight.bold,
            fontSize: 18),
        border: borderStyles(),
      ),
      onTap: () {
        setState(() {
          hint = "";
        });
      },
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (text) {
        setState(() {
          inputRules = text;
        });
      },
    );
  }
}
