import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'result_screen.dart';
import 'notification_screen.dart';
import 'login_screen.dart';
import 'crud/activity_list_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () async {
              await AuthService.instance.signOut(); // REMOVE LOGIN SESSION

              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5CFC7),

      // 🔹 APP BAR WITH LOGOUT TEXT + ICON
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Home"),
        actions: [
          TextButton.icon(
            onPressed: () => showLogoutDialog(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              sectionTitle("Time Available"),
              optionRow(["5 min", "15 min", "30 min", "60 min"]),

              sectionTitle("Energy Level"),
              optionRow(["Low", "Medium", "High"]),

              sectionTitle("Mental State"),
              optionRow(["Bored", "Tired", "Focused"]),

              sectionTitle("Location"),
              optionRow(["Home", "Outside"]),

              const SizedBox(height: 30),

              // Suggest Activity
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ResultScreen(),
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
                  child: const Text(
                    "Suggest Activity",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Notifications
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
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
                  child: const Text(
                    "View Notifications",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // Manage Activities (CRUD)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActivityListScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Distinct color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "Manage Activities",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Section title widget
  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 🔹 Options widget
  Widget optionRow(List<String> options) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: options.map((option) {
        return OutlinedButton(
          onPressed: () {},
          child: Text(option),
        );
      }).toList(),
    );
  }
}
