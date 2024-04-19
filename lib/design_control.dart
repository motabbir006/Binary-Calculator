import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BinaryCalculator extends StatefulWidget {
  @override
  _BinaryCalculatorState createState() => _BinaryCalculatorState();
}

class _BinaryCalculatorState extends State<BinaryCalculator> {
  String userInput = '';
  String answer = '';
  List<String> history = [];
  List<String> undoHistory = [];

  void addToInput(String value) {
    setState(() {
      userInput += value;
    });
  }

  void clearInput() {
    setState(() {
      userInput = '';
      answer = '';
      history.clear();
      undoHistory.clear();
    });
  }

  void deleteLastCharacter() {
    setState(() {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
      }
    });
  }

  void calculate() {
    setState(() {
      try {
        answer = _evaluateExpression(userInput).toRadixString(2);
        history.add(userInput + ' = ' + answer);
        undoHistory.clear();
      } catch (e) {
        answer = 'Error';
      }
    });
  }

  void undo() {
    setState(() {
      if (history.isNotEmpty) {
        String lastExpression = history.removeLast().split(' = ')[0];
        undoHistory.add(lastExpression);
        userInput = history.isNotEmpty ? history.last.split(' = ')[0] : '';
        answer = '';
      }
    });
  }

  void redo() {
    setState(() {
      if (undoHistory.isNotEmpty) {
        String nextExpression = undoHistory.removeLast();
        history.add(nextExpression + ' = ' + _evaluateExpression(nextExpression).toRadixString(2));
        userInput = nextExpression;
        answer = history.last.split(' = ')[1];
      }
    });
  }

  int _evaluateExpression(String expression) {
    List<String> operators = ['+', '-', '×', '÷'];
    String currentNumber = '';
    List<int> numbers = [];
    List<String> operatorsList = [];

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (char == '+' || char == '-' || char == '×' || char == '÷') {
        operatorsList.add(char);
        if (currentNumber.isNotEmpty) {
          numbers.add(int.parse(currentNumber, radix: 2));
          currentNumber = '';
        }
      } else {
        currentNumber += char;
      }
    }

    if (currentNumber.isNotEmpty) {
      numbers.add(int.parse(currentNumber, radix: 2));
    }

    int result = numbers[0];
    for (int i = 0; i < operatorsList.length; i++) {
      String operator = operatorsList[i];
      int operand = numbers[i + 1];

      if (operator == '+') {
        result += operand;
      } else if (operator == '-') {
        result -= operand;
      } else if (operator == '×') {
        result *= operand;
      } else if (operator == '÷') {
        result ~/= operand; // Integer division
      }
    }

    return result;
  }

  Widget buildButton(String buttonText, Function() onTap) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: buttonText == 'C' || buttonText == 'DEL'
                  ? Icon(
                buttonText == 'C'
                    ? FontAwesomeIcons.times
                    : FontAwesomeIcons.backspace,
                size: 25,
              )
                  : Text(
                buttonText,
                style: TextStyle(fontSize: 35),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binary Calculator',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            color: Colors.white60,
            onPressed: undo,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: redo,
            color: Colors.white60,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                userInput,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                answer.toString(),
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  buildButton('1', () {
                    addToInput('1');
                  }),
                  buildButton('0', () {
                    addToInput('0');
                  }),
                  buildButton('DEL', deleteLastCharacter),
                  buildButton('C', clearInput),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  buildButton('+', () {
                    addToInput('+');
                  }),
                  buildButton('-', () {
                    addToInput('-');
                  }),
                  buildButton('×', () {
                    addToInput('×');
                  }),
                  buildButton('÷', () {
                    addToInput('÷');
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: calculate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '=',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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
}
