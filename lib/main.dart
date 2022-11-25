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
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 3", 5),
    RulesMap(DateTime.now(), "규칙 4", 5),
  ];

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    // ignore: no_leading_underscores_for_local_identifiers
    OutlineInputBorder _border() {
      return OutlineInputBorder(
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(20));
    }

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
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    filled: true,
                    fillColor: const Color.fromARGB(31, 255, 255, 255),
                    disabledBorder: _border(),
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 180, 180, 180),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    border: _border(),
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
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: deviceWidth,
              color: Colors.white12,
              height: 1,
            ),
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
            Column(
              children: [
                ListView.builder(
                    itemCount: Rules.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (c, i) {
                      return Card(
                        color: Color.fromARGB(255, 227, 227, 227),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: deviceWidth - 50,
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: null,
                              text: TextSpan(
                                text: Rules[i].description,
                                style: const TextStyle(
                                  color: Colors.black,
                                  height: 1.4,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
