import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../providers/expenses_provider.dart';
import '../models/expense.dart';
import '../widgets/main_scaffold.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? _selectedCategory;
  String? _selectedSubcategory;
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final expenses = _filterExpenses(expensesProvider.expenses);
    final isDarkMode = expensesProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final chartColor = isDarkMode ? Colors.grey[850]! : Colors.grey[200]!;

    final categoryDistribution = _getCategoryDistribution(expenses);
    _getMonthlySpending(expensesProvider.expenses);

    return MainScaffold(
      title: 'Raporlar',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilters(expensesProvider, textColor, cardColor),
            const SizedBox(height: 10),
            _buildMonthPicker(textColor, cardColor),
            Expanded(
              child: ListView(
                children: [
                  _buildSummaryCards(expenses, textColor, cardColor),
                  _buildChartCard(
                    title: 'Aylık Harcama Dağılımı',
                    child: _buildBarChart(categoryDistribution, textColor, isDarkMode),
                    textColor: textColor,
                    backgroundColor: chartColor,
                  ),
                  _buildTopExpenses(expenses, textColor, cardColor),
                  _buildExpenseDetailsTable(expenses, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
      selectedIndex: 1,
      onItemTapped: (index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
        } else if (index == 1) {
          Navigator.pushNamed(context, '/reports');
        }
      },
      showSettingsIcon: true, // Add this line
    );
  }

  List<Expense> _filterExpenses(List<Expense> expenses) {
    return expenses.where((expense) {
      final matchCategory = _selectedCategory == null || _selectedCategory == 'Hepsi' || expense.category.split(' -> ')[0] == _selectedCategory;
      final matchSubcategory = _selectedSubcategory == null || expense.category == '$_selectedCategory -> $_selectedSubcategory';
      final matchMonth = expense.date.year == _selectedMonth.year && expense.date.month == _selectedMonth.month;
      return matchCategory && matchSubcategory && matchMonth;
    }).toList();
  }

  Widget _buildFilters(ExpensesProvider expensesProvider, Color textColor, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDropdownFilter('Kategori', _getCategoryItems(expensesProvider), (selectedCategory) {
                    setState(() {
                      _selectedCategory = selectedCategory;
                      _selectedSubcategory = null;
                    });
                  }, textColor, cardColor),
                ),
                const SizedBox(width: 10),
                if (_selectedCategory != null && _selectedCategory != 'Hepsi')
                  Expanded(
                    child: _buildDropdownFilter('Alt Kategori', _getSubcategoryItems(expensesProvider), (selectedSubcategory) {
                      setState(() {
                        _selectedSubcategory = selectedSubcategory;
                      });
                    }, textColor, cardColor),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(String label, List<DropdownMenuItem<String>> items, Function(String?) onChanged, Color textColor, Color cardColor) {
    return DropdownButtonFormField<String>(
      value: label == 'Kategori' ? _selectedCategory ?? 'Hepsi' : _selectedSubcategory,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: cardColor,
      ),
      items: items,
      onChanged: onChanged,
      dropdownColor: cardColor, // Set dropdown background color for dark mode
      style: TextStyle(color: textColor), // Set text color for dropdown items
    );
  }

  List<DropdownMenuItem<String>> _getCategoryItems(ExpensesProvider expensesProvider) {
    final categories = ['Hepsi'] + expensesProvider.categories.keys.toList();
    return categories.map((category) {
      return DropdownMenuItem<String>(
        value: category,
        child: Text(category),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _getSubcategoryItems(ExpensesProvider expensesProvider) {
    if (_selectedCategory == null || _selectedCategory == 'Hepsi') return [];
    final subcategories = expensesProvider.categories[_selectedCategory!] ?? [];
    return subcategories.map((subcategory) {
      return DropdownMenuItem<String>(
        value: subcategory,
        child: Text(subcategory),
      );
    }).toList();
  }

  Widget _buildMonthPicker(Color textColor, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Seçilen Ay: ${DateFormat.yMMM('tr_TR').format(_selectedMonth)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            ElevatedButton(
              onPressed: _selectMonth,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: const Color.fromARGB(255, 34, 197, 94),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Ay Seç'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectMonth() async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = picked;
      });
    }
  }

  Widget _buildSummaryCards(List<Expense> expenses, Color textColor, Color cardColor) {
    double totalAmount = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    int totalTransactions = expenses.length;
    double avgAmount = totalTransactions > 0 ? totalAmount / totalTransactions : 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryCard('Toplam Tutar', '${totalAmount.toStringAsFixed(2)} ₺', Icons.monetization_on, textColor, cardColor),
        _buildSummaryCard('Toplam İşlem', '$totalTransactions', Icons.receipt_long, textColor, cardColor),
        _buildSummaryCard('Ort. Tutar', '${avgAmount.toStringAsFixed(2)} ₺', Icons.bar_chart, textColor, cardColor),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color textColor, Color cardColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color.fromARGB(255, 34, 197, 94)),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 20, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child, required Color textColor, required Color backgroundColor}) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            SizedBox(height: 300, child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> categoryDistribution, Color textColor, bool isDarkMode) {
    final sortedCategoryDistribution = categoryDistribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        labelStyle: TextStyle(color: textColor),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: textColor),
        numberFormat: NumberFormat.compactCurrency(symbol: '₺', locale: 'tr_TR'),
      ),
      series: [
        ColumnSeries<_ChartData, String>(
          dataSource: sortedCategoryDistribution.map((entry) => _ChartData(entry.key, entry.value)).toList(),
          xValueMapper: (_ChartData data, _) => data.category,
          yValueMapper: (_ChartData data, _) => data.amount,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: textColor),
          ),
          color: const Color.fromARGB(255, 34, 197, 94),
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        format: 'point.x : point.y₺',
        textStyle: TextStyle(color: textColor),
        color: isDarkMode ? Colors.black87 : Colors.white,
      ),
    );
  }

  Widget _buildTopExpenses(List<Expense> expenses, Color textColor, Color cardColor) {
    final topExpenses = List<Expense>.from(expenses)..sort((a, b) => b.amount.compareTo(a.amount));
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('En Yüksek 5 Harcama', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            ...topExpenses.take(5).map((expense) {
              return ListTile(
                title: Text(expense.name, style: TextStyle(color: textColor)),
                subtitle: Text('${expense.category} - ${DateFormat.yMMMd('tr_TR').format(expense.date)}', style: TextStyle(color: textColor.withOpacity(0.7))),
                trailing: Text('${expense.amount.toStringAsFixed(2)} ₺', style: TextStyle(color: textColor)),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseDetailsTable(List<Expense> expenses, bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return Card(
      color: isDarkMode ? Colors.grey[800]! : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harcama Detayları', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Tarih', style: TextStyle(color: textColor))),
                  DataColumn(label: Text('Kategori', style: TextStyle(color: textColor))),
                  DataColumn(label: Text('Tutar', style: TextStyle(color: textColor))),
                  DataColumn(label: Text('İsim', style: TextStyle(color: textColor))),
                ],
                rows: expenses.map((expense) {
                  return DataRow(cells: [
                    DataCell(Text(DateFormat.yMMMd('tr_TR').format(expense.date), style: TextStyle(color: textColor))),
                    DataCell(Text(expense.category, style: TextStyle(color: textColor))),
                    DataCell(Text('${expense.amount.toStringAsFixed(2)} ₺', style: TextStyle(color: textColor))),
                    DataCell(Text(expense.name, style: TextStyle(color: textColor))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _getCategoryDistribution(List<Expense> expenses) {
    final Map<String, double> categoryDistribution = {};

    for (var expense in expenses) {
      final mainCategory = expense.category.split(' -> ')[0];
      if (categoryDistribution.containsKey(mainCategory)) {
        categoryDistribution[mainCategory] = categoryDistribution[mainCategory]! + expense.amount;
      } else {
        categoryDistribution[mainCategory] = expense.amount;
      }
    }

    return categoryDistribution;
  }

  Map<DateTime, double> _getMonthlySpending(List<Expense> expenses) {
    final Map<DateTime, double> monthlySpending = {};

    for (var expense in expenses) {
      final date = DateTime(expense.date.year, expense.date.month);
      if (monthlySpending.containsKey(date)) {
        monthlySpending[date] = monthlySpending[date]! + expense.amount;
      } else {
        monthlySpending[date] = expense.amount;
      }
    }

    return monthlySpending;
  }
}

class _ChartData {
  _ChartData(this.category, this.amount);

  final String category;
  final double amount;
}

Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  Locale? locale,
}) async {
  DateTime? selectedDate;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ay Seç'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = DateTime(initialDate.year, index + 1, 1);
              return GestureDetector(
                onTap: () {
                  selectedDate = month;
                  Navigator.pop(context);
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Center(
                    child: Text(
                      DateFormat.MMM(locale?.languageCode).format(month),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
  return selectedDate;
}
