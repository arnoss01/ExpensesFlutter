import 'package:flutter/material.dart';
import 'package:fluttercontrol/ExpenseDetailsPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'expense_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    final String apiUrl = 'http://127.0.0.1:8082/api/v1/expense';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonDataList = json.decode(response.body);
        setState(() {
          expenses = jsonDataList.map((data) => Expense.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        showSnackbar('Failed to fetch expenses');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Exception: $e');
      showSnackbar('An error occurred');
      setState(() {
        isLoading = false;
      });
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
        title: Text('Expense App'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return ExpenseCard(expense: expenses[index], onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseDetailsPage(expense: expenses[index]),
              ),
            );
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExpenseListPage(expenses: expenses)),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onPressed;

  ExpenseCard({required this.expense, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text('Amount: \$${expense.ammount.toStringAsFixed(2)}'), // Format amount
        onTap: onPressed,
      ),
    );
  }
}

class Expense {
  String title;
  String description;
  DateTime spendingDate;
  double ammount;
  int expenseCategoryId;

  Expense({
    required this.title,
    required this.description,
    required this.spendingDate,
    required this.ammount,
    required this.expenseCategoryId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      title: json['title'],
      description: json['description'],
      spendingDate: DateTime.parse(json['spendingDate']),
      ammount: json['ammount'] != null ? json['ammount'].toDouble() : 0.0,
      expenseCategoryId: json['expenseCategoryId'],
    );
  }
}
