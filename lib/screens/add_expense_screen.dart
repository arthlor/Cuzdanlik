import 'package:cuzdanlik/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../providers/expenses_provider.dart';
import '../widgets/main_scaffold.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Diğer';
  String? _selectedSubcategory;
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  String _recurrenceInterval = 'Yok';

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _nameController.text = widget.expense!.name;
      _amountController.text = widget.expense!.amount.toString();
      _selectedCategory = widget.expense!.category.split(' -> ')[0];
      _selectedSubcategory = widget.expense!.category.contains(' -> ')
          ? widget.expense!.category.split(' -> ')[1]
          : null;
      _selectedDate = widget.expense!.date;
      _isRecurring = widget.expense!.isRecurring;
      _recurrenceInterval = widget.expense!.recurrenceInterval;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<ExpensesProvider>(context);
    final isDarkMode = expensesProvider.isDarkMode;

    return MainScaffold(
      title: widget.expense != null ? 'Gideri Güncelle' : 'Gider Ekle',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCard(
                child: CustomTextField(
                  controller: _nameController,
                  labelText: 'Gider Adı *',
                ),
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                child: CustomTextField(
                  controller: _amountController,
                  labelText: 'Tutar *',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori *',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    CustomDropdown(
                      title: '',
                      value: _selectedCategory,
                      items: Expense.categoryIcons.keys
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Row(
                                  children: [
                                    Icon(
                                      Expense.categoryIcons[category],
                                      color: const Color.fromARGB(255, 34, 197, 94),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                          _selectedSubcategory = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              if (expensesProvider.categories[_selectedCategory] != null)
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alt Kategori',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      CustomDropdown(
                        title: '',
                        value: _selectedSubcategory,
                        items: expensesProvider.categories[_selectedCategory]!
                            .map((subcategory) => DropdownMenuItem(
                                  value: subcategory,
                                  child: Text(
                                    subcategory,
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubcategory = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16.0),
              _buildCard(
                child: _buildDatePicker(context),
              ),
              const SizedBox(height: 16.0),
              _buildCard(
                child: SwitchListTile(
                  title: const Text('Düzenli Harcama'),
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                  activeColor: const Color.fromARGB(255, 34, 197, 94),
                ),
              ),
              const SizedBox(height: 16.0),
              if (_isRecurring)
                _buildCard(
                  child: CustomDropdown(
                    title: 'Tekrar Aralığı',
                    value: _recurrenceInterval,
                    items: ['Yok', 'Günlük', 'Aylık', 'Yıllık']
                        .map((interval) => DropdownMenuItem(
                              value: interval,
                              child: Text(
                                interval,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _recurrenceInterval = value!;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 24.0), backgroundColor: const Color.fromARGB(255, 34, 197, 94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  widget.expense != null ? 'Güncelle' : 'Ekle',
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      selectedIndex: 0,
      onItemTapped: (index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
        } else if (index == 1) {
          Navigator.pushNamed(context, '/reports');
        }
      },
      showSettingsIcon: true,
    );
  }

  Widget _buildCard({required Widget child}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Tarih',
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      trailing: TextButton(
        onPressed: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            builder: (context, child) {
              return Theme(
                data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
                child: child!,
              );
            },
          );
          if (pickedDate != null && pickedDate != _selectedDate) {
            setState(() {
              _selectedDate = pickedDate;
            });
          }
        },
        child: Text(
          DateFormat.yMMMd().format(_selectedDate),
          style: const TextStyle(color: Color.fromARGB(255, 34, 197, 94)),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final category = _selectedSubcategory != null
          ? '$_selectedCategory -> $_selectedSubcategory'
          : _selectedCategory;
      final newExpense = Expense(
        id: widget.expense?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        category: category,
        date: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          TimeOfDay.now().hour,
          TimeOfDay.now().minute,
        ),
        icon: Expense.categoryIcons[_selectedCategory]!, // Ensure the icon is provided
        isRecurring: _isRecurring,
        recurrenceInterval: _recurrenceInterval,
      );
      final expensesProvider =
          Provider.of<ExpensesProvider>(context, listen: false);
      if (widget.expense != null) {
        final index = expensesProvider.expenses.indexWhere((e) => e.id == widget.expense!.id);
        expensesProvider.updateExpense(index, newExpense);
      } else {
        expensesProvider.addExpense(newExpense);
      }
      Navigator.pop(context);
    }
  }
}
