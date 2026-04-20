import 'package:flutter/material.dart';

class UserTab extends StatelessWidget {
  const UserTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader("Account"),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Profile"),
            onTap: () {}, 
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text("Privacy & Security"),
            onTap: () {},
          ),
          
          _buildSectionHeader("Preferences"),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text("Dark Mode"),
            value: false,
            onChanged: (bool value) {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text("Notifications"),
            onTap: () {},
          ),

          _buildSectionHeader("About"),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Version"),
            subtitle: const Text("1.0.0"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent, 
        ),
      ),
    );
  }
}