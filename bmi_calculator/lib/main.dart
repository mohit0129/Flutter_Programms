import 'package:flutter/material.dart';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BMICalculatorPage(),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  String result = "";
  Color resultColor = Colors.black;

  // Function to calculate BMI and determine category
  void calculateBMI() {
    double height = double.parse(heightController.text) / 100; // Convert cm to meters
    double weight = double.parse(weightController.text);
    double bmi = weight / (height * height);

    setState(() {
      if (bmi < 18.5) {
        result = "Underweight: BMI ${bmi.toStringAsFixed(2)}";
        resultColor = Colors.orangeAccent;
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        result = "Normal: BMI ${bmi.toStringAsFixed(2)}";
        resultColor = Colors.green;
      } else {
        result = "Overweight: BMI ${bmi.toStringAsFixed(2)}";
        resultColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Age Input Field
              buildInputField('Age(Years)', ageController),

              // Height Input Field
              buildInputField('Height (cm)', heightController),

              // Weight Input Field
              buildInputField('Weight (kg)', weightController),

              // Calculate Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    calculateBMI();
                  }
                },
                child: Text('Calculate'),
              ),

              // Display Result
              SizedBox(height: 20),
              Text(
                result,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: resultColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Input Field
  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (double.tryParse(value) == null || double.parse(value) <= 0) {
            return 'Please enter a valid $label';
          }
          return null;
        },
      ),
    );
  }
}
