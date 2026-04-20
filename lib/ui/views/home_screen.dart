import 'package:flutter/material.dart';
import 'catalog_tab.dart'; // Import the file you just created
// You will create these other files next (see below)
import 'home_tab.dart'; 
import 'ar_screen.dart';
import 'user_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // This list holds all your main pages
  final List<Widget> _pages = [
    const HomeTab(),
    const ArScreen(),
    CatalogTab(), // This is the CatalogTab you created in the previous step
    const UserTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed, // Essential if you have 4+ items
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'AR'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}