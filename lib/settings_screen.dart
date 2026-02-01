import 'package:flutter/material.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5CFC7),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFFD5CFC7),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Preferences",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            SwitchListTile(
              value: true,
              onChanged: (value) {},
              title: const Text("Enable Notifications"),
            ),

            SwitchListTile(
              value: false,
              onChanged: (value) {},
              title: const Text("Dark Mode"),
            ),

            const SizedBox(height: 20),

            const Text(
              "About",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "What Should I Do Now?\nVersion 1.0\nHelps users decide activities instantly.",
            ),

            const SizedBox(height: 30),

            // 👇 THIS IS THE NEW BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
              ),
              child: const Text("View Profile"),
            ),

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
