import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expenses_provider.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final bool isDarkMode;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final backgroundColor = expensesProvider.getCategoryColor(expense.category);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(expense.icon, color: Colors.white),
        ),
        title: Text(
          expense.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          '${DateFormat.yMMMMd('tr_TR').format(expense.date)} ${DateFormat.Hm('tr_TR').format(expense.date)}',
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${expense.amount.toStringAsFixed(2)} ₺',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 34, 197, 94),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 34, 197, 94)),
              onPressed: () {
                Navigator.pushNamed(context, '/add_expense', arguments: expense);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                expensesProvider.removeExpense(expense);
              },
            ),
          ],
        ),
      ),
    );
  }
}
