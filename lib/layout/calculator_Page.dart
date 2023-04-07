import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';

  void _handleButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
      } else if (buttonText == '=') {
        _display = evalExpression(_display).toString();
      } else if (_display == '0' && buttonText != '.') {
        _display = buttonText;
      } else {
        _display += buttonText;
      }
    });
  }

  double evalExpression(String expression) {
    String p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.bottomRight,
            child: Text(
              _display,
              style: TextStyle(fontSize: 48.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              buildButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('0'),
              buildButton('.'),
              buildButton('C'),
              buildButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('('),
              buildButton(')'),
              buildButton('^'),
              buildButton('='),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText) {
    return ElevatedButton(
      onPressed: () {
        _handleButtonPressed(buttonText);
      },
      child: Text(buttonText),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(24.0),
        primary: Colors.blue,
        textStyle: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
