class Activity {
  final String id;
  final String title;
  final String description;
  final String duration; // "5 min", "15 min", etc.
  final String energyLevel; // "Low", "Medium", "High"
  final String location; // "Home", "Outside"
  final DateTime date;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.energyLevel,
    required this.location,
    required this.date,
  });

  // Convert Activity object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'energyLevel': energyLevel,
      'location': location,
      'date': date.toIso8601String(),
    };
  }

  // Create Activity object from Firestore Snapshot (Map)
  factory Activity.fromMap(String id, Map<String, dynamic> map) {
    return Activity(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      duration: map['duration'] ?? '',
      energyLevel: map['energyLevel'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] != null 
          ? DateTime.parse(map['date']) 
          : DateTime.now(), // Fallback for old data
    );
  }
}
