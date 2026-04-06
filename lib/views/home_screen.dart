import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/navigation_viewmodel.dart';
import 'tabs/home_tab.dart';
import 'tabs/ar_tab.dart';
import 'tabs/catalog_tab.dart';
import 'tabs/user_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<NavigationViewModel>(context);

    final screens = [
      const HomeTab(),
      const ARTab(),
      const CatalogTab(),
      const UserTab(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[vm.currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: vm.changeTab,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"),

          BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar),
              label: "AR Camera"),

          BottomNavigationBarItem(
              icon: Icon(Icons.chair),
              label: "Catalog"),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "User"),
        ],
        
        selectedIconTheme: const IconThemeData(size:24, color:Color.fromARGB(255, 118, 121, 115)),
        unselectedIconTheme: const IconThemeData()
      ),
    );
  }
}