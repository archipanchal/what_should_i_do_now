import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart'; // Import the model

class ActivityService {
  final CollectionReference _activityCollection =
      FirebaseFirestore.instance.collection('activities');

  // CREATE: Add a new activity
  Future<void> addActivity(Activity activity) {
    return _activityCollection.add(activity.toMap());
  }

  // READ: Get all activities as a Stream
  Stream<List<Activity>> getActivities() {
    return _activityCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Activity.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE: Update an existing activity
  Future<void> updateActivity(Activity activity) {
    return _activityCollection.doc(activity.id).update(activity.toMap());
  }

  // DELETE: Delete an activity
  Future<void> deleteActivity(String id) {
    return _activityCollection.doc(id).delete();
  }
}
