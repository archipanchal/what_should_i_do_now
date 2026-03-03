import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final String displayName = user?.displayName != null && user!.displayName!.isNotEmpty
            ? user.displayName!
            : user?.email?.split('@')[0] ?? "User";
        final String email = user?.email ?? "No Email";

        return Scaffold(
          backgroundColor: const Color(0xFFD5CFC7),
          appBar: AppBar(
            title: const Text("Profile"),
            backgroundColor: const Color(0xFFD5CFC7),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                const Card(
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text("App Version"),
                    subtitle: Text("1.0.0"),
                  ),
                ),

                const Card(
                  child: ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text("About App"),
                    subtitle: Text("Helps users decide what to do instantly"),
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: () {
                    // Pop back to home (or previous screen)
                    // If using named routes properly, pop works fine.
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
              ],
            ),
          ),
        );
      },
    );
  }
}
