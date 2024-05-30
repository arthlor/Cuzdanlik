import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_list_item.dart';

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
