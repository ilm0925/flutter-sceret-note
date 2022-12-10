import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:secret_note/components/ratingBar.dart';
import 'package:secret_note/components/ruleInput.dart';
import 'package:secret_note/components/ruleWidget.dart';
import 'package:secret_note/crypto.dart';
import 'package:secret_note/key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Custom_Widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {
  // ignore: non_constant_identifier_names
  var Rules = [];
  String title = "";
  double deviceWidth = 300;
  late String key;
  double rating = 3;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController ruleController = TextEditingController();
  void getRules() async {
    SharedPreferences prefs = await _prefs;
    List<String>? importedRules = prefs.getStringList("rules");
    if (importedRules == null || importedRules.isEmpty) {
      setState(() {
        title = "규칙 추가하기";
        Rules = [];
      });
      return;
    }
    setState(() {
      Rules = importedRules;
      title = "이건 꼭 지키기";
    });
  }

  void dropRule(int index) async {
    SharedPreferences pref = await _prefs;
    List<String>? importedRules = pref.getStringList("rules");
    if (importedRules == null) {
      return;
    }
    importedRules.removeAt(index);
    pref.setStringList("rules", importedRules);
    setState(() {
      Rules = importedRules;
      if (Rules.isEmpty) {
        title = "규칙 추가하기";
      }
    });
  }

  void addRule(List<String> rule) async {
    if (ruleController.text.length < 3) {
      return Alert("내용이 너무 적음", context);
    }
    SharedPreferences pref = await _prefs;
    List<String>? importedRules = pref.getStringList("rules");
    importedRules ??= [];
    Crypto crypto = Crypto(key);
    rule[1] = crypto.encryptBase64(rule[1]);
    importedRules.add(json.encode(rule));

    //   importedRules.removeLast();
    //   print(importedRules);
    pref.setStringList("rules", importedRules);

    setState(() {
      Rules = importedRules!;
      title = "이건 꼭 지키기";
    });
  }

  changeRating(double star) {
    setState(() {
      rating = star;
    });
  }

  @override
  void initState() {
    super.initState();
    getRules();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 188, 188, 188),
      appBar: Nav(true, context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: deviceWidth - 50,
                    child: ruleInput(
                      addRule: addRule,
                      rating: rating,
                      ruleController: ruleController,
                      borderStyles: borderStyles,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Star(
                    chageRating: changeRating,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            line(),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 30),
            ),
            const SizedBox(height: 10),
            Column(
              children: [boxBuilder()],
            )
          ],
        ),
      ),
    );
  }

  dynamic boxBuilder() {
    return ListView.builder(
        itemCount: Rules.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (c, i) {
          return Column(
            children: [
              RuleWidget(
                rule: Rules[i],
                idx: i,
                popup: popup,
                deviceWidth: deviceWidth,
              ),
              line()
            ],
          );
        });
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

  void popup(String rule, String Date, String rating, int index, context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Column(
              children: [
                Text(Date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                RatingBarIndicator(
                  direction: Axis.horizontal,
                  itemCount: 5,
                  rating: double.parse(rating),
                  itemSize: 18,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber[200],
                  ),
                ),
              ],
            ),
            content: Container(
              constraints: BoxConstraints(maxHeight: 100, minHeight: 25),
              child: SingleChildScrollView(
                child: Text(rule,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () {
                  dropRule(index);
                  Navigator.pop(context);
                },
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceAround,
          );
        });
  }
}
