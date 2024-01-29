import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with TickerProviderStateMixin {
  String enteredNumbers = '';
  Color backcolor = const Color(0xFFFFECC4);
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDEB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('C A L C U L A T O R'),
      ),
      body: Column(
        children: [
          // First Section
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        enteredNumbers,
                        style: const TextStyle(color: Colors.black, fontSize: 60.0),
                      ),
                    ),
                    BlinkingCursor(controller: _cursorController),
                  ],
                ),
              ),
            ),
          ),
          // Second Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // First Column
                  Expanded(
                    child: Row(
                      children: [
                        buildButton("C", backgroundColor: backcolor, onPressed: () => clear()),
                        buildButton("Del", backgroundColor: backcolor, onPressed: () => delete()),
                        buildButton("%", backgroundColor: backcolor, onPressed: () => calculatePercentage()),
                        buildButton("÷", backgroundColor: backcolor, onPressed: () => divide()),
                      ],
                    ),
                  ),
                  // Second Column
                  Expanded(
                    child: Row(
                      children: [
                        buildButton("7", onPressed: () => append('7')),
                        buildButton("8", onPressed: () => append('8')),
                        buildButton("9", onPressed: () => append('9')),
                        buildButton("x", backgroundColor: backcolor, onPressed: () => multiply()),
                      ],
                    ),
                  ),
                  // Third Column
                  Expanded(
                    child: Row(
                      children: [
                        buildButton("4", onPressed: () => append('4')),
                        buildButton("5", onPressed: () => append('5')),
                        buildButton("6", onPressed: () => append('6')),
                        buildButton("+", backgroundColor: backcolor, onPressed: () => add()),
                      ],
                    ),
                  ),
                  // Fourth Column
                  Expanded(
                    child: Row(
                      children: [
                        buildButton("1", onPressed: () => append('1')),
                        buildButton("2", onPressed: () => append('2')),
                        buildButton("3", onPressed: () => append('3')),
                        buildButton("−", backgroundColor: backcolor, onPressed: () => subtract()),
                      ],
                    ),
                  ),
                  // Fifth Column
                  Expanded(
                    child: Row(
                      children: [
                        buildButton("0", onPressed: () => append('0')),
                        buildButton(".", onPressed: () => append('.')), // Specify width for "."
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: buildButton("=", backgroundColor: const Color(0xFFFEC03C), width: 165.0, onPressed: () => calculate()),
                        ), // Larger width for "="
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(
      String text,
      {
        Color backgroundColor = const Color(0xFFEFEFEF),
        double fontSize = 24.0,
        double width = 80.0,
        void Function()? onPressed
      }
      ) {
    return Expanded(
      child: Container(
        width: width,
        height: 80.0,
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20.0, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void append(String value) {
    setState(() {
      enteredNumbers += value;
    });
  }

  void clear() {
    setState(() {
      enteredNumbers = '';
    });
  }

  void delete() {
    setState(() {
      if (enteredNumbers.isNotEmpty) {
        enteredNumbers = enteredNumbers.substring(0, enteredNumbers.length - 1);
      }
    });
  }

  void calculate() {
    try {
      // Use the 'dart:math' library to evaluate the mathematical expression
      double result = Parser().parse(enteredNumbers).evaluate(EvaluationType.REAL, ContextModel());

      // Update the enteredNumbers with the result
      setState(() {
        enteredNumbers = result.toString();
      });
    } catch (e) {
      // Handle any parsing or evaluation errors
      setState(() {
        enteredNumbers = 'Error';
      });
    }
  }

  void add() {
    append('+');
  }

  void subtract() {
    append('-');
  }

  void multiply() {
    append('*');
  }

  void divide() {
    append('/');
  }

  void calculatePercentage() {
    try {
      // Calculate percentage by dividing enteredNumbers by 100
      double result = Parser().parse(enteredNumbers + '/100').evaluate(EvaluationType.REAL, ContextModel());

      // Update the enteredNumbers with the result
      setState(() {
        enteredNumbers = result.toString();
      });
    } catch (e) {
      // Handle any parsing or evaluation errors
      setState(() {
        enteredNumbers = 'Error';
      });
    }
  }
}

class BlinkingCursor extends StatelessWidget {
  final AnimationController controller;

  const BlinkingCursor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 2.0).animate(controller),
      child: Container(
        width: 2.0, // Adjust the width of the cursor
        height: 70.0, // Adjust the height of the cursor
        color: Colors.black,
      ),
    );
  }
}
