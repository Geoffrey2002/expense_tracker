import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter learning",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Movie ",
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];

//function for opening a modal
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      //the modal to stay away from the system bar ie the camera
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      //add new expense
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

// function for adding a new expense
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

//function to remove expense
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    //adding a message notification and undo the removal
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted."),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some!"),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Expense Tracker"),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  //add expanded so that it could render a list inside a list which is column
                  Expanded(
                    child: mainContent,
                  )
                ],
              )
            : Row(
                children: [
                  //to take as much width as available in the row
                  Expanded(
                    child: Chart(expenses: _registeredExpenses),
                  ),
                  //add expanded so that it could render a list inside a list which is column
                  Expanded(
                    child: mainContent,
                  )
                ],
              ));
  }
}
