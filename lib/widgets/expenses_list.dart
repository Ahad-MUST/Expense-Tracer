import 'package:expense_tracer/models/expense.dart';
import 'package:expense_tracer/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  ExpenseList({super.key, required this.expenses, required this.removeexpense});

  final List<Expense> expenses;

  void Function(Expense expense) removeexpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(
              color: const Color.fromARGB(255, 234, 230, 230).withOpacity(.50),
              margin: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal),
            ),
            onDismissed: (direction) {
              return removeexpense(expenses[index]);
            },
            child: ExpenseItem(expense: expenses[index]),
          );
        });
  }
}
