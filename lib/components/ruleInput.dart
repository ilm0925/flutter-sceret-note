
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ruleInput extends StatelessWidget {
  const ruleInput({super.key,this.borderStyles,this.addRule,this.rating,this.ruleController});
  
  final borderStyles;
  final ruleController;
  final rating;
  final addRule;

  @override
  Widget build(BuildContext context) {
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
        controller: ruleController,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
     
      ),
    );
  }
}