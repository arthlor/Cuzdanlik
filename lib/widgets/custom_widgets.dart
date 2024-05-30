import 'package:cuzdanlik/models/expense.dart';
import 'package:cuzdanlik/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double elevation;

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.elevation = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = color ?? (isDarkMode ? Colors.grey[850] : Colors.white);

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: elevation,
      margin: margin ?? const EdgeInsets.all(8.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.white70 : Colors.black54;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
        hintStyle: TextStyle(color: hintColor),
      ),
      style: TextStyle(color: textColor),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen $labelText girin';
        }
        return null;
      },
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String title;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}

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

class PaginatedExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final bool isDarkMode;

  const PaginatedExpenseList({
    super.key,
    required this.expenses,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    int itemsPerPage = 5;
    int currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        final startIndex = currentPage * itemsPerPage;
        final endIndex = (startIndex + itemsPerPage) < expenses.length
            ? (startIndex + itemsPerPage)
            : expenses.length;
        final itemsToDisplay = expenses.sublist(startIndex, endIndex);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itemsToDisplay.length,
                itemBuilder: (context, index) {
                  final expense = itemsToDisplay[index];
                  return ExpenseListItem(expense: expense, isDarkMode: isDarkMode);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: currentPage > 0 ? const Color.fromARGB(255, 34, 197, 94) : Colors.grey,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
                ),
                Text(
                  '${currentPage + 1} / ${(expenses.length / itemsPerPage).ceil()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: endIndex < expenses.length
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: endIndex < expenses.length ? const Color.fromARGB(255, 34, 197, 94) : Colors.grey,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Icon(Icons.chevron_right, size: 32, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (expenses.length / itemsPerPage).ceil(),
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == index ? const Color.fromARGB(255, 34, 197, 94) : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
