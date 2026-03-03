import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityService _activityService = ActivityService();
  List<Activity> _activities = [];
  bool _isLoading = false;

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;

  // Filter only favorite activities
  List<Activity> get favoriteActivities => 
      _activities.where((activity) => activity.isFavorite).toList();

  ActivityProvider() {
    _loadActivities();
  }

  // Initial Load (Listen to Stream)
  void _loadActivities() {
    _isLoading = true;
    notifyListeners();

    _activityService.getActivities().listen((activityList) {
      _activities = activityList;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
       // Handle error silently or logging
       _isLoading = false;
       notifyListeners();
    });
  }

  // Toggle Favorite Status
  Future<void> toggleFavorite(Activity activity) async {
    final newStatus = !activity.isFavorite;
    
    // Optimistic update (update UI immediately)
    final index = _activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
       // We can't modify the object directly as it is final, creating a copy
       // But waiting for Firestore is safer for sync
    }

    // Update in Firestore
    final updatedActivity = Activity(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      duration: activity.duration,
      energyLevel: activity.energyLevel,
      location: activity.location,
      date: activity.date,
      isFavorite: newStatus,
    );

    await _activityService.updateActivity(updatedActivity);
    // Stream listener will update the list automatically
  }

  Future<void> deleteActivity(String id) async {
    await _activityService.deleteActivity(id);
  }
}
