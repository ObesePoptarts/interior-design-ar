import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const HomeTab({super.key, required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chair_outlined, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                "Welcome to DecorAR",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Visualize beautiful furniture in your room instantly.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Sign In to Settings"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: onLoginPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}