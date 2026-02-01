import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5CFC7),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFFD5CFC7),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          NotificationCard(
            text: "Try a short walk to refresh your mind.",
          ),
          NotificationCard(
            text: "Listening to music can improve your mood.",
          ),
          NotificationCard(
            text: "Take a 5-minute break from screen time.",
          ),
          NotificationCard(
            text: "Stretch your body to reduce stress.",
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String text;

  const NotificationCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
