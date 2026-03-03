import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableNotifications = true;
  double _textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use theme background color automatically
      appBar: AppBar(
        title: const Text("Settings"),
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
              value: _enableNotifications,
              onChanged: (value) {
                setState(() => _enableNotifications = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? "Notifications Enabled" : "Notifications Disabled"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              title: const Text("Enable Notifications"),
              secondary: const Icon(Icons.notifications),
            ),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                  title: const Text("Dark Mode"),
                  secondary: const Icon(Icons.dark_mode),
                );
              },
            ),

            const SizedBox(height: 10),
            
            Text("Text Scale: ${_textScale.toStringAsFixed(1)}x"),
            Slider(
              value: _textScale,
              min: 0.5,
              max: 2.0,
              divisions: 3,
              label: "${_textScale.toStringAsFixed(1)}x",
              onChanged: (value) {
                setState(() => _textScale = value);
              },
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
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("View Profile"),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
