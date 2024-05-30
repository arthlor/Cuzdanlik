import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/expense.dart';

class ExpensesProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  String _currency = '₺';
  bool _isDarkMode = false;
  final Map<String, Color> _categoryColors = {};

  List<Expense> get expenses => _expenses;
  String get currency => _currency;
  bool get isDarkMode => _isDarkMode;

  ExpensesProvider() {
    loadExpenses();
    _initializeCategoryColors();
  }

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesData = prefs.getString('expenses');
    if (expensesData != null) {
      final decodedData = json.decode(expensesData) as List;
      _expenses = decodedData.map((expense) => Expense.fromJson(expense)).toList();
    }
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesData = json.encode(_expenses.map((expense) => expense.toJson()).toList());
    prefs.setString('expenses', expensesData);
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    saveExpenses();
    notifyListeners();
  }

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    saveExpenses();
    notifyListeners();
  }

  void updateExpense(int index, Expense expense) {
    _expenses[index] = expense;
    saveExpenses();
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void toggleDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    saveExpenses();
    notifyListeners();
  }

  Map<String, List<String>> get categories => {
    'Kira': ['Ev Kirası', 'Ofis Kirası', 'Depo Kirası'],
    'Faturalar': ['Elektrik', 'Su', 'Doğalgaz', 'İnternet', 'Telefon', 'Kablo TV', 'Aidat'],
    'Market': ['Gıda', 'İçecekler', 'Temizlik Ürünleri', 'Kişisel Bakım', 'Evcil Hayvan Ürünleri'],
    'Eğlence': ['Sinema', 'Tiyatro', 'Konser', 'Spor', 'Abonelikler (Netflix, Spotify)', 'Oyunlar', 'Kültürel Etkinlikler'],
    'Ulaşım': ['Benzin', 'Toplu Taşıma', 'Taksi', 'Araç Bakımı', 'Otopark', 'Araç Kiralama', 'Uçak Bileti', 'Tren Bileti'],
    'Sağlık': ['İlaçlar', 'Doktor', 'Hastane', 'Spor', 'Diş Hekimi', 'Gözlük ve Lens', 'Sağlık Sigortası', 'Terapist'],
    'Yeme-İçme': ['Restoran', 'Kafe', 'Fast Food', 'Ev Yemeği', 'Bar', 'Paket Servis'],
    'Eğitim': ['Kitaplar', 'Kurslar', 'Okul Ücretleri', 'Seminerler', 'Online Eğitimler', 'Yabancı Dil Kursları'],
    'Diğer': ['Hediye', 'Kırtasiye', 'Giyim', 'Ev Dekorasyonu', 'Elektronik', 'Tatiller', 'Bahçe Malzemeleri', 'Hayır İşleri'],
  };

  Map<String, IconData> get categoryIcons => {
    'Kira': Icons.home,
    'Faturalar': Icons.electrical_services,
    'Market': Icons.shopping_cart,
    'Eğlence': Icons.movie,
    'Ulaşım': Icons.directions_car,
    'Sağlık': Icons.local_hospital,
    'Yeme-İçme': Icons.restaurant,
    'Eğitim': Icons.school,
    'Diğer': Icons.category,
  };

  void _initializeCategoryColors() {
    final random = Random();
    const darkPastelColors = [
      Color(0xFF8B4513), Color(0xFF556B2F), Color(0xFF6B8E23), Color(0xFF2F4F4F), Color(0xFF4B0082),
      Color(0xFF483D8B), Color(0xFF2E8B57), Color(0xFF4682B4), Color(0xFF708090), Color(0xFF6A5ACD),
      Color(0xFF7B68EE), Color(0xFF800080), Color(0xFF8A2BE2), Color(0xFF9370DB), Color(0xFF8B0000),
      Color(0xFF9932CC), Color(0xFF8FBC8F), Color(0xFF8B4513), Color(0xFFA52A2A), Color(0xFF5F9EA0),
    ];

    categories.forEach((category, subcategories) {
      _categoryColors[category] = darkPastelColors[random.nextInt(darkPastelColors.length)];
      for (var subcategory in subcategories) {
        _categoryColors['$category -> $subcategory'] = darkPastelColors[random.nextInt(darkPastelColors.length)];
      }
    });
  }

  Color getCategoryColor(String category) {
    return _categoryColors[category] ?? Colors.black;
  }
}
