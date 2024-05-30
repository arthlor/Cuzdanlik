import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './providers/expenses_provider.dart';
import './screens/add_expense_screen.dart';
import './screens/reports_screen.dart';
import './screens/about_screen.dart';
import './screens/main_screen.dart';
import './screens/settings_screen.dart';
import './models/expense.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpensesProvider(),
      child: Consumer<ExpensesProvider>(
        builder: (context, expensesProvider, _) {
          return MaterialApp(
            title: 'Cüzdanlık',
            theme: ThemeData(
              primarySwatch: Colors.green,
              primaryColor: const Color.fromARGB(255, 34, 197, 94),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 34, 197, 94),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color.fromARGB(255, 34, 197, 94),
                foregroundColor: Colors.white,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Color.fromARGB(255, 34, 197, 94),
                unselectedItemColor: Colors.grey,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(fontFamily: 'Roboto'),
                bodyMedium: TextStyle(fontFamily: 'Roboto'),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: const Color.fromARGB(255, 34, 197, 94),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 34, 197, 94),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color.fromARGB(255, 34, 197, 94),
                foregroundColor: Colors.white,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Color.fromARGB(255, 34, 197, 94),
                unselectedItemColor: Colors.grey,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(fontFamily: 'Roboto'),
                bodyMedium: TextStyle(fontFamily: 'Roboto'),
              ),
            ),
            themeMode: expensesProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('tr', 'TR'),
            ],
            initialRoute: '/',
            routes: {
              '/': (context) => const MainScreen(),
              '/add_expense': (context) {
                final Expense? expense = ModalRoute.of(context)!.settings.arguments as Expense?;
                return AddExpenseScreen(expense: expense);
              },
              '/reports': (context) => const ReportsScreen(),
              '/about': (context) => const AboutScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
