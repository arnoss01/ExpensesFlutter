import 'package:flutter/material.dart';
import 'package:fluttercontrol/main.dart';

class ExpenseListPage extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseListPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Expenses'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(expenses[index].title),
            subtitle: Text('Amount: \$${expenses[index].ammount}'),
            // Add more details as needed
          );
        },
      ),
    );
  }
}
