import 'package:expense_tracer/models/expense.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class NewExpense extends StatefulWidget {
  NewExpense({required this.addexpense, super.key});
  void Function(Expense expense) addexpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titlecontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  Category selectedcategory = Category.leisure;
  DateTime? selectedate;

  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  bool isvalidInput() {
    if (_titlecontroller.text.trim().isEmpty ||
        double.tryParse(_amountcontroller.text) == null ||
        double.parse(_amountcontroller.text) <= 0 ||
        selectedate == null) {
      return false;
    } else {
      return true;
    }
  }

  void _presentdatepicker() async {
    final fisrtdate = DateTime(DateTime.now().year - 1,
        DateTime.now().month - 1, DateTime.now().day - 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: fisrtdate,
      lastDate: DateTime.now(),
    );
    setState(() {
      selectedate = pickedDate;
    });
  }

  void showdialogbox() {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please add a valid title, amount and category'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('OK'))
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please add a valid title, amount and category'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('OK'))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardspace + 16),
          child: Column(
            children: [
              TextField(
                controller: _titlecontroller,
                maxLength: 20,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLength: 10,
                      controller: _amountcontroller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedate == null
                              ? 'No date Selected'
                              : formatter.format(selectedate!),
                        ),
                        IconButton(
                          onPressed: () {
                            _presentdatepicker();
                          },
                          icon: const Icon(Icons.calendar_month_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    DropdownButton(
                        value: selectedcategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            selectedcategory = value;
                          });
                        }),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                    ElevatedButton(
                      onPressed: () {
                        if (isvalidInput()) {
                          widget.addexpense(
                            Expense(
                                amount: double.parse(_amountcontroller.text),
                                date: selectedate!,
                                title: _titlecontroller.text.toString(),
                                category: selectedcategory),
                          );
                          Navigator.pop(context);
                        } else {
                          showdialogbox();
                        }
                      },
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
