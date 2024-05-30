import 'package:cuzdanlik/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expenses_provider.dart';
import '../widgets/main_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushNamed(context, '/reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final today = DateTime.now();
    double totalExpenses = 0.0;
    for (var expense in expensesProvider.expenses) {
      if (expense.date.day == today.day &&
          expense.date.month == today.month &&
          expense.date.year == today.year) {
        totalExpenses += expense.amount;
      }
    }

    final isDarkMode = expensesProvider.isDarkMode;
    List<String> tips = [
      "Ben olsam indirime girmesini beklerdim.",
      "Sence de hayat çok pahalı değil mi?",
      "Haftaya aynısı üç harfli marketlere gelecek.",
      "Alsam mı bilemiyorum, girl math???.",
      "Bu fiyata bu ürün şaka mı???",
      "Her bankaya borcum, o kızda gönlüm var.",
      "Bunu alırsan haftasonu beach yerine evde Kızılcık Şerbo var.",
    ];

    Widget buildDailyTip(DateTime date) {
      int tipIndex = date.day % tips.length;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: Color.fromARGB(255, 34, 197, 94)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tips[tipIndex],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final sortedExpenses = List<Expense>.from(expensesProvider.expenses)
      ..sort((a, b) => b.date.compareTo(a.date));

    return MainScaffold(
      title: 'Cüzdanlık',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bugün Harcadığım Para',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${totalExpenses.toStringAsFixed(2)} ₺',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.list, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Tüm Harcamalar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/reports');
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Hepsini Gör',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 34, 197, 94),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Color.fromARGB(255, 34, 197, 94)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: sortedExpenses.length > 5
                  ? PaginatedExpenseList(
                      expenses: sortedExpenses,
                      isDarkMode: isDarkMode,
                    )
                  : ListView.builder(
                      itemCount: sortedExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = sortedExpenses[index];
                        return ExpenseListItem(expense: expense, isDarkMode: isDarkMode);
                      },
                    ),
            ),
            buildDailyTip(today),
          ],
        ),
      ),
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      onFABPressed: () {
        Navigator.pushNamed(context, '/add_expense');
      },
      showSettingsIcon: true,
      showFAB: true,
      isMainPage: true,
    );
  }
}
