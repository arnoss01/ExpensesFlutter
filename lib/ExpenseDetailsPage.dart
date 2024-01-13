import 'package:flutter/material.dart';
import 'package:fluttercontrol/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseDetailsPage extends StatefulWidget {
  final Expense expense;

  ExpenseDetailsPage({required this.expense});

  @override
  _ExpenseDetailsPageState createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  late ExpenseCategory expenseCategory;

  @override
  void initState() {
    super.initState();
    expenseCategory = ExpenseCategory(id: 0, name: ''); // Initialize with default values
    fetchExpenseCategory();
  }

  Future<void> fetchExpenseCategory() async {
    final String apiUrl =
        'http://127.0.0.1:8082/api/v1/expenseCategory/${widget.expense.expenseCategoryId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          expenseCategory = ExpenseCategory.fromJson(jsonData);
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        showSnackbar('Failed to fetch expense category');
      }
    } catch (e) {
      print('Exception: $e');
      showSnackbar('An error occurred');
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Title: ${widget.expense.title}'),
          Text('Amount: \$${widget.expense.ammount.toStringAsFixed(2)}'),
          FutureBuilder(
            future: fetchExpenseCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Text('Category: ${expenseCategory.name}');
              }
            },
          ),
          // Add more details as needed
        ],
      ),
    );
  }
}

class ExpenseCategory {
  int id;
  String name;

  ExpenseCategory({required this.id, required this.name});

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
