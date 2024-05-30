import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String name;
  final double amount;
  final String category;
  final DateTime date;
  final IconData icon;
  final bool isRecurring;
  final String recurrenceInterval;

  static const Map<String, IconData> categoryIcons = {
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

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.icon,
    this.isRecurring = false,
    this.recurrenceInterval = 'Yok',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'icon': icon.codePoint,
      'isRecurring': isRecurring,
      'recurrenceInterval': recurrenceInterval,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      icon: categoryIcons[json['category']] ?? Icons.category,
      isRecurring: json['isRecurring'] ?? false,
      recurrenceInterval: json['recurrenceInterval'] ?? 'Yok',
    );
  }
}
