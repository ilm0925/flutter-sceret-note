import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:secret_note/crypto.dart';

import '../key.dart';

class RuleWidget extends StatefulWidget {
  const RuleWidget(
      {super.key,
      required this.rule,
      required this.idx,
      this.popup,
      required this.deviceWidth});
  final String rule;
  final int idx;
  final popup;
  final double deviceWidth;
  @override
  State<RuleWidget> createState() => _ruleWidgetState();
}

class _ruleWidgetState extends State<RuleWidget> {
  late String key;
  bool showState = false;

  @override
  Widget build(BuildContext context) {
    key = Provider.of<KeyProvider>(context).getKey ?? "1234567812345678";
    if (showState) {
      return ruleBox(json.decode(widget.rule), widget.idx);
    }
    return InkWell(
      onTap: () {
        setState(() {
          showState = false;
        });
      },
      child: const Card(
        color: Color.fromARGB(31, 67, 67, 67),
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.visibility,
              color: Colors.white,
            )),
      ),
    );
  }

  dynamic ruleCard(String description, String Date, String rating, int index,
      BuildContext context) {
    return InkWell(
      onTap: () {
        widget.popup(description, Date, rating, index, context);
      },
      onDoubleTap: () {
        setState(() {
          showState = false;
        });
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
                  width: widget.deviceWidth - 50,
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
}
