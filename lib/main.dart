import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/navigation_viewmodel.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AR Decor App',
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}