import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";  // To keep track of user input (numbers and operators)
  String display = "0";  // To show the expression and result
  double firstOperand = 0;
  String operator = "";
  double secondOperand = 0;

  // Function to handle button clicks
  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        // Clear everything
        input = "";
        display = "0";
        firstOperand = 0;
        secondOperand = 0;
        operator = "";
      } else if (value == "+" || value == "-" || value == "*" || value == "/") {
        // Operator is pressed
        if (input.isNotEmpty) {
          firstOperand = double.parse(input);  // Save the first number
          operator = value;  // Save the operator
          input = "";  // Clear input for second number
        }
      } else if (value == "=") {
        // Equals is pressed
        if (input.isNotEmpty && operator.isNotEmpty) {
          secondOperand = double.parse(input);  // Save the second number
          double result = _calculateResult(firstOperand, secondOperand, operator);
          display = result.toString();  // Show the result
          input = result.toString();  // Reset input to the result for further operations
          operator = "";  // Clear the operator after calculation
        }
      } else {
        // Numbers and decimals
        input += value;  // Append to input
      }

      // Update display to show the full expression including operators
      if (operator.isNotEmpty) {
        display = "$firstOperand $operator $input";  // Show expression with operator
      } else {
        display = input.isEmpty ? "0" : input;  // If input is empty, show 0
      }
    });
  }

  // Simple calculation logic for basic operators
  double _calculateResult(double first, double second, String op) {
    switch (op) {
      case "+":
        return first + second;
      case "-":
        return first - second;
      case "*":
        return first * second;
      case "/":
        if (second != 0) {
          return first / second;
        } else {
          return 0;  // Handle divide by zero case
        }
      default:
        return 0;
    }
  }

  // Widget for a single button
  Widget buildButton(String text, Color color) {
    return SizedBox(
      width: 50, // Smaller width for buttons
      height: 50, // Smaller height for buttons
      child: ElevatedButton(
        onPressed: () => buttonPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display Screen
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(24),
            child: Text(
              display,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),

          // Buttons Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 4, // 4 buttons per row
              padding: EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                buildButton("7", Colors.blue),
                buildButton("8", Colors.blue),
                buildButton("9", Colors.blue),
                buildButton("/", Colors.orange),

                buildButton("4", Colors.blue),
                buildButton("5", Colors.blue),
                buildButton("6", Colors.blue),
                buildButton("*", Colors.orange),

                buildButton("1", Colors.blue),
                buildButton("2", Colors.blue),
                buildButton("3", Colors.blue),
                buildButton("-", Colors.orange),

                buildButton("C", Colors.red),
                buildButton("0", Colors.blue),
                buildButton("=", Colors.green),
                buildButton("+", Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
