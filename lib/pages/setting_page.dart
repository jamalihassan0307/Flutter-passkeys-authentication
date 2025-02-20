import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text('Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Enable dark theme'),
              value: false,
              onChanged: (bool value) {
                // Handle theme change
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading:
                  const Icon(Icons.notifications, color: Colors.deepPurple),
              title: const Text('Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Manage notification settings'),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to notification settings
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.lock, color: Colors.deepPurple),
              title: const Text('Privacy',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Manage privacy settings'),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to privacy settings
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.deepPurple),
              title: const Text('About',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Learn more about this app'),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to about page
              },
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  )),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
