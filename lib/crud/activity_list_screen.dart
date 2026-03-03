import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import 'add_activity_screen.dart';
import 'edit_activity_screen.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5CFC7),
      appBar: AppBar(
        title: const Text("Manage Activities"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, activityProvider, child) {
          if (activityProvider.isLoading) {
             return const Center(child: CircularProgressIndicator());
          }

          final activities = activityProvider.activities;

          if (activities.isEmpty) {
            return const Center(child: Text("No activities found. Add one!"));
          }

          return ListView.builder(
            itemCount: activities.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Dismissible(
                key: Key(activity.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  activityProvider.deleteActivity(activity.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${activity.title} deleted")),
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      activity.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${activity.duration} • ${activity.energyLevel} • ${activity.location}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Favorite Button
                        IconButton(
                          icon: Icon(
                            activity.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: activity.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            activityProvider.toggleFavorite(activity);
                          },
                        ),
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditActivityScreen(activity: activity),
                              ),
                            );
                          },
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, activity.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddActivityScreen()),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String activityId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Activity"),
        content: const Text("Are you sure you want to delete this activity?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<ActivityProvider>().deleteActivity(activityId);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
