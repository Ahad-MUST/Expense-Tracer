import 'package:expense_tracer/new_expense.dart';
import 'package:expense_tracer/widgets/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracer/widgets/chart/chart.dart';
import 'package:expense_tracer/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _expense();
  }
}

List<Expense> registeredexpenses = [
  Expense(
    amount: 19.99,
    date: DateTime.now(),
    title: 'flutter course',
    category: Category.work,
  ),
  Expense(
    amount: 10.69,
    date: DateTime.now(),
    title: 'Cinema',
    category: Category.leisure,
  )
];

class _expense extends State<Expenses> {
  void addexpense(Expense expense) {
    setState(() {
      registeredexpenses.add(expense);
    });
  }

  void removeexpense(Expense expense) {
    int index = registeredexpenses.indexOf(expense);
    setState(
      () {
        registeredexpenses.remove(expense);
      },
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                registeredexpenses.insert(index, expense);
              });
            }),
      ),
    );
  }

  void _openExpensesoverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(
          addexpense: addexpense,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget maincontext = const Center(
      child: Text('No expenses found. Start Adding new'),
    );
    if (registeredexpenses.isNotEmpty) {
      maincontext = ExpenseList(
          expenses: registeredexpenses, removeexpense: removeexpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          IconButton(
            onPressed: _openExpensesoverlay,
            icon: const Icon(Icons.add),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        ],
      ),
      body: width < 500
          ? Column(
              children: [
                Chart(expenses: registeredexpenses),
                Expanded(
                  child: maincontext,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: registeredexpenses),
                ),
                Expanded(
                  child: maincontext,
                ),
              ],
            ),
    );
  }
}
