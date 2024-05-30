import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool showFAB;
  final VoidCallback? onFABPressed;
  final bool showSettingsIcon;
  final bool isMainPage;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.selectedIndex,
    required this.onItemTapped,
    this.showFAB = false,
    this.onFABPressed,
    this.showSettingsIcon = true,
    this.isMainPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: !isMainPage && Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: Row(
          children: [
            Image.asset(
              'assets/applogo.png',
              height: 32,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (showSettingsIcon)
            IconButton(
              icon: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
        ],
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: onFABPressed,
              backgroundColor: const Color.fromARGB(255, 34, 197, 94),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Icon(Icons.home, size: 28, color: Color.fromARGB(255, 34, 197, 94)),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Icon(Icons.show_chart, size: 28, color: Color.fromARGB(255, 34, 197, 94)),
            ),
            label: '',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 34, 197, 94),
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
