import 'package:flutter/material.dart';

void main() => runApp(ExpenseTrackerApp());

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AddExpensePage(),
    );
  }
}

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  // Controllers for input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Default to today's date

  // List to store expenses (this will hold all added expenses)
  List<Map<String, dynamic>> expenses = [];

  // Method to show the date picker and select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Method to add a new expense
  void _addExpense() {
    String title = titleController.text;
    String description = descriptionController.text;

    // Validate the title (description is optional)
    if (title.isNotEmpty) {
      setState(() {
        expenses.add({
          'title': title,
          'description': description.isNotEmpty ? description : 'No description', // If no description, set default text
          'date': selectedDate,
        });
      });

      // Clear the fields after adding the expense
      titleController.clear();
      descriptionController.clear();
    } else {
      // Show a SnackBar if the title is empty (as it's mandatory)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title is required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title*'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context), // Open the date picker
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addExpense, // Add expense when pressed
                child: Text('Add Expense'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Expense List page
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ExpenseListPage(expenses: expenses),
                  ));
                },
                child: Text('View Added Expenses'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseListPage extends StatelessWidget {
  final List<Map<String, dynamic>> expenses;

  ExpenseListPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Added Expenses'),
      ),
      body: expenses.isEmpty
          ? Center(child: Text('No expenses added yet!'))
          : ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) {
          final expense = expenses[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                  '${expense['date'].day}/${expense['date'].month}'), // Display date as avatar
            ),
            title: Text(expense['title']),
            subtitle: Text(expense['description']), // Show description or 'No description'
          );
        },
      ),
    );
  }
}
