import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String email;

  const ProfilePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              email,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.deepPurple),
                    title: const Text('Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle:
                        const Text('ALi Hassan'), // Replace with actual name
                  ),
                  Divider(),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.deepPurple),
                    title: const Text('Email',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(email),
                  ),
                  Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.deepPurple),
                    title: const Text('Phone',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text(
                        '+923073921189'), // Replace with actual phone number
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
