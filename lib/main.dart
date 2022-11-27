import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:secret_note/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Custom_Widgets.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/note': (context) => const MyApp(),
    },
    home: const Login(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String hint = "규칙 입력";
  String inputRules = "규칙을 추가해주세요";

  // ignore: non_constant_identifier_names
  var Rules = [];
  String title = "";
  double deviceWidth = 300;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getRules() async {
    SharedPreferences prefs = await _prefs;
    List<String>? importedRules = prefs.getStringList("rules");
    if (importedRules == null) {
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

  void addRule(List<String> rule) async {
    SharedPreferences pref = await _prefs;
    List<String>? importedRules = pref.getStringList("rules");
    importedRules ??= [];
    // importedRules.add(jsonEncode(Rule));
    importedRules.add(json.encode(rule));
    pref.setStringList("rules", importedRules);
    setState(() {
      Rules = importedRules!;
    });
  }

  @override
  void initState() {
    super.initState();
    getRules();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 188, 188, 188),
      appBar: Nav(true),
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
            children: [ruleBox(json.decode(Rules[i])), line()],
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

  InkWell ruleBox(List<dynamic> rule) {
    return InkWell(
      onTap: () {
        popup(rule[1]);
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
                text: rule[1],
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
      onSubmitted: (text) {
        addRule([DateTime.now().toString(), text, 5.toString()]);
      },
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

  void popup(String rule) {
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
}
