import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _displayController = TextEditingController();

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _displayController.clear();
      } else if (value == '=') {
        _evaluateExpression();
      } else {
        _displayController.text += value;
      }
    });
  }

  void _evaluateExpression() {
    try {
      final expression = Expression.parse(_displayController.text);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      _displayController.text = result.toString();
    } catch (e) {
      _displayController.text = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator by GitHub Copilot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: TextField(
                controller: _displayController,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(border: InputBorder.none),
                readOnly: true,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.maxWidth / (constraints.maxHeight / 5);
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    final buttons = [
                      '7', '8', '9', '/',
                      '4', '5', '6', '*',
                      '1', '2', '3', '-',
                      'C', '0', '=', '+'
                    ];
                    return ElevatedButton(
                      onPressed: () {
                        _onButtonPressed(buttons[index]);
                      },
                      child: Text(buttons[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}