import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  String inputRules = "규칙을 추가해주세요";

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

  @override
  void initState() {
    super.initState();
    getRules();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    key = Provider.of<KeyProvider>(context).getKey ?? "1234567812345678";
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
                    child: ruleInput(borderStyles),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RatingBar.builder(
                    glowRadius: 0.1,
                    glowColor: Colors.amber[300],
                    initialRating: 2.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 35,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber[600],
                    ),
                    onRatingUpdate: (star) {
                      setState(() {
                        rating = star;
                      });
                    },
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
              ruleBox(json.decode(Rules[i]), i),
              line(),
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

  InkWell ruleCard(String description, String Date, String rating, int index,
      BuildContext context) {
    return InkWell(
      onTap: () {
        popup(description, Date, rating, index, context);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromARGB(255, 188, 188, 188),
            ),
            borderRadius: BorderRadius.circular(20)),
        color: const Color.fromARGB(31, 67, 67, 67),
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: deviceWidth - 50,
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: null,
                    text: TextSpan(
                      text: description.replaceAll("\n", " "),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 232, 231, 231),
                          height: 1.4,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic ruleBox(List<dynamic> rule, int index) {
    Crypto crypto = Crypto(key);
    String description;
    try {
      description = crypto.decryptBase64(rule[1]);
    } catch (e) {
      description = "복호화 실패";
    }
    return ruleCard(description, rule[0], rule[2], index, context);
  }

  Padding ruleInput(OutlineInputBorder Function() borderStyles) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          suffixIcon: InkWell(
            child: const Icon(
              Icons.send,
            ),
            onTap: () {
              addRule([
                DateFormat('yyyy년MM월dd일').format(DateTime.now()),
                ruleController.text,
                rating.toString()
              ]);
              ruleController.clear();
            },
          ),
          suffixIconColor: Colors.red,
          hintText: "내용 입력",
          filled: true,
          fillColor: const Color.fromARGB(31, 255, 255, 255),
          disabledBorder: borderStyles(),
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 180, 180, 180),
              fontWeight: FontWeight.bold,
              fontSize: 18),
          border: borderStyles(),
        ),
        // onSubmitted: (text) {
        //   addRule([
        //     DateFormat('yyyy년MM월dd일').format(DateTime.now()),
        //     text,
        //     5.toString()
        //   ]);
        // },
        controller: ruleController,
        textAlign: TextAlign.left,
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
