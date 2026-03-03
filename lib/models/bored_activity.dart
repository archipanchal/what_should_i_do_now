class BoredActivity {
  final String activity;
  final String type;
  final int participants;
  final double price;
  final double accessibility;
  final String key;

  BoredActivity({
    required this.activity,
    required this.type,
    required this.participants,
    required this.price,
    required this.accessibility,
    required this.key,
  });

  factory BoredActivity.fromJson(Map<String, dynamic> json) {
    return BoredActivity(
      activity: json['activity'] as String? ?? 'Unknown Activity',
      type: json['type'] as String? ?? 'general',
      participants: json['participants'] as int? ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      accessibility: (json['accessibility'] as num?)?.toDouble() ?? 0.5,
      key: json['key']?.toString() ?? '',
    );
  }

  /// User-friendly label for the type
  String get typeLabel {
    switch (type.toLowerCase()) {
      case 'education':
        return '📚 Education';
      case 'recreational':
        return '🎮 Recreational';
      case 'social':
        return '👥 Social';
      case 'diy':
        return '🔧 DIY';
      case 'charity':
        return '❤️ Charity';
      case 'cooking':
        return '🍳 Cooking';
      case 'relaxation':
        return '🧘 Relaxation';
      case 'music':
        return '🎵 Music';
      case 'busywork':
        return '📋 Busywork';
      default:
        return '✨ ${type[0].toUpperCase()}${type.substring(1)}';
    }
  }
}
