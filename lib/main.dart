import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'parser.dart'

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> keypads = [
    "7",
    "8",
    "9",
    "+",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "x",
    "0",
    ".",
    "<",
    "/",
    "CE",
    "="
  ];

  bool isOperator({required String label}) {
    return label == "+" ||
        label == "-" ||
        label == "x" ||
        label == "*" ||
        label == "/";
  }

  String answer = "545";

  String input = "";

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Simple Calculator"),
        centerTitle: true,
        actions: [
          Icon(
            Icons.history,
            color: Colors.white,
          ),
          SizedBox(width: 20),
        ],
      ),
      drawer: Drawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              answer,
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
              ),
            ),
            SizedBox(height: 20),
            Text(
              input,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 120),
            Expanded(
              child: GridView.builder(
                  itemCount: keypads.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final String keypad = keypads[index];
                    return TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: isOperator(label: keypad)
                            ? Colors.blue
                            : Colors.blueGrey,
                        shape: isOperator(label: keypad)
                            ? CircleBorder()
                            : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                      ),
                      onPressed: () {
                        handleKeyOnPressed(keypad: keypad);
                      },
                      child: Text(
                        keypad,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      /*   bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          height: 350,
          decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
        ),
      ), */
    );
  }
  String calcInput() {
    print("inputValue: $input");
    final result = buildParser().parse(input);
    if (result.isSuccess) {
      print(result.value);
      setState(() {
        answer = result.value.toString();
      });
      return result.value.toString();
    } else {
      setState(() {
        answer = "Syntax Error";
      });
    }
    print("Syntax Error $result");
    return "Syntax Error";
  }


  void handleKeyOnPressed({required String keypad}) {
    setState(() {
      if (keypad == "CE") {
        input = "";
        answer = "";
      } else if (keypad == "<" && input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      } else if (keypad == "0") {
        if (input.isEmpty)
          input = keypad;
        else if (input.length == 1 && input == keypad)
          return;
        else
          input += keypad;
      } else if (keypad == ".") {
        if (input.isEmpty) input = "0.";
        else if (!input.contains(".")) input += keypad;
        
      }else if(keypad == "="){
          calcInput();
        } else {
        input += keypad;
      }
    });
  }
}
