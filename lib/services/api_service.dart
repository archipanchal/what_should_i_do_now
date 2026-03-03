import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/bored_activity.dart';
import '../models/quote.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 8);

  // Reliable fallback activities organized by category
  static const Map<String, List<Map<String, dynamic>>> _fallbackActivities = {
    'all': [
      {'activity': 'Learn a new recipe and cook it from scratch', 'type': 'cooking', 'participants': 1, 'price': 0.2, 'accessibility': 0.2},
      {'activity': 'Go for a 30-minute walk in a new neighborhood', 'type': 'recreational', 'participants': 1, 'price': 0.0, 'accessibility': 0.1},
      {'activity': 'Call a friend or family member you haven\'t spoken to in a while', 'type': 'social', 'participants': 2, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Read a chapter of a book you\'ve been putting off', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Learn 10 words in a new language using an app', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Rearrange the furniture in one room of your home', 'type': 'diy', 'participants': 1, 'price': 0.0, 'accessibility': 0.3},
      {'activity': 'Write a short story or journal entry', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Try a new stretching or yoga routine on YouTube', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Play a board game or card game with someone', 'type': 'social', 'participants': 2, 'price': 0.1, 'accessibility': 0.1},
      {'activity': 'Watch a documentary about a topic you know nothing about', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Declutter one drawer or shelf at home', 'type': 'diy', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Learn to play a simple song on any instrument', 'type': 'music', 'participants': 1, 'price': 0.0, 'accessibility': 0.3},
      {'activity': 'Plan and prepare meal preps for the week', 'type': 'cooking', 'participants': 1, 'price': 0.3, 'accessibility': 0.1},
      {'activity': 'Donate unused clothes or items to a local charity', 'type': 'charity', 'participants': 1, 'price': 0.0, 'accessibility': 0.1},
      {'activity': 'Do a 20-minute meditation session', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Organize a surprise for a loved one', 'type': 'social', 'participants': 2, 'price': 0.2, 'accessibility': 0.1},
      {'activity': 'Plant an herb or vegetable in a pot', 'type': 'recreational', 'participants': 1, 'price': 0.1, 'accessibility': 0.1},
      {'activity': 'Listen to an entire album from start to finish', 'type': 'music', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Bake something sweet from scratch', 'type': 'cooking', 'participants': 1, 'price': 0.2, 'accessibility': 0.1},
      {'activity': 'Write a list of 10 things you are grateful for', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
    ],
    'education': [
      {'activity': 'Watch a TED Talk on a topic that challenges your views', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Learn to touch type using a free typing website', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Study the history of a country you\'ve never visited', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Learn basic coding with a free platform like Scratch or Python', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Read a Wikipedia article on a random topic', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Complete an online quiz about general knowledge', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Study the basics of astronomy and star patterns', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Learn about the stock market and basic investing concepts', 'type': 'education', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
    ],
    'recreational': [
      {'activity': 'Go on a spontaneous bike ride', 'type': 'recreational', 'participants': 1, 'price': 0.0, 'accessibility': 0.2},
      {'activity': 'Try solving a jigsaw puzzle', 'type': 'recreational', 'participants': 1, 'price': 0.1, 'accessibility': 0.1},
      {'activity': 'Visit a local park you\'ve never been to', 'type': 'recreational', 'participants': 1, 'price': 0.0, 'accessibility': 0.1},
      {'activity': 'Play a video game you\'ve been meaning to try', 'type': 'recreational', 'participants': 1, 'price': 0.1, 'accessibility': 0.0},
      {'activity': 'Try a new sport or physical activity for 30 minutes', 'type': 'recreational', 'participants': 1, 'price': 0.1, 'accessibility': 0.3},
      {'activity': 'Fly a kite on a windy day', 'type': 'recreational', 'participants': 1, 'price': 0.1, 'accessibility': 0.2},
      {'activity': 'Do a photo walk — take 20 interesting photos around you', 'type': 'recreational', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
    ],
    'social': [
      {'activity': 'Host a movie night with friends', 'type': 'social', 'participants': 4, 'price': 0.1, 'accessibility': 0.1},
      {'activity': 'Organize a group hiking trip', 'type': 'social', 'participants': 4, 'price': 0.1, 'accessibility': 0.3},
      {'activity': 'Start a group chat to reconnect with old classmates', 'type': 'social', 'participants': 3, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Cook a meal together with a friend or family member', 'type': 'social', 'participants': 2, 'price': 0.2, 'accessibility': 0.1},
      {'activity': 'Play online multiplayer games with a friend', 'type': 'social', 'participants': 2, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Teach someone a skill you are good at', 'type': 'social', 'participants': 2, 'price': 0.0, 'accessibility': 0.0},
    ],
    'cooking': [
      {'activity': 'Try making sushi from scratch', 'type': 'cooking', 'participants': 1, 'price': 0.4, 'accessibility': 0.3},
      {'activity': 'Bake sourdough bread', 'type': 'cooking', 'participants': 1, 'price': 0.2, 'accessibility': 0.2},
      {'activity': 'Make homemade pasta', 'type': 'cooking', 'participants': 1, 'price': 0.2, 'accessibility': 0.2},
      {'activity': 'Explore a new cuisine — try cooking Thai or Ethiopian food', 'type': 'cooking', 'participants': 1, 'price': 0.3, 'accessibility': 0.2},
      {'activity': 'Make a smoothie bowl with creative toppings', 'type': 'cooking', 'participants': 1, 'price': 0.2, 'accessibility': 0.1},
      {'activity': 'Try fermenting something — kimchi or yogurt', 'type': 'cooking', 'participants': 1, 'price': 0.2, 'accessibility': 0.3},
    ],
    'relaxation': [
      {'activity': 'Practice 4-7-8 breathing technique for 10 minutes', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Take a long bath with music and no phone', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Do a full body progressive muscle relaxation session', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Spend an hour doing absolutely nothing — just sit outside', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Draw or doodle freely without any goal', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Listen to nature sounds and practice mindfulness', 'type': 'relaxation', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
    ],
    'music': [
      {'activity': 'Learn the lyrics of your favorite song', 'type': 'music', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Create a playlist for every mood', 'type': 'music', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Try beatboxing or vocal percussion for fun', 'type': 'music', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Research the history of a genre of music you enjoy', 'type': 'music', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Learn basic music theory — notes, scales, and chords', 'type': 'music', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
    ],
    'diy': [
      {'activity': 'Build a small bookshelf from inexpensive materials', 'type': 'diy', 'participants': 1, 'price': 0.3, 'accessibility': 0.4},
      {'activity': 'Upcycle an old T-shirt into something new', 'type': 'diy', 'participants': 1, 'price': 0.0, 'accessibility': 0.1},
      {'activity': 'Make scented candles at home', 'type': 'diy', 'participants': 1, 'price': 0.3, 'accessibility': 0.2},
      {'activity': 'Repair something broken around the house', 'type': 'diy', 'participants': 1, 'price': 0.1, 'accessibility': 0.3},
      {'activity': 'Create a vision board for your goals', 'type': 'diy', 'participants': 1, 'price': 0.1, 'accessibility': 0.0},
    ],
    'charity': [
      {'activity': 'Volunteer at a local food bank or shelter', 'type': 'charity', 'participants': 1, 'price': 0.0, 'accessibility': 0.1},
      {'activity': 'Organize a neighborhood cleanup', 'type': 'charity', 'participants': 3, 'price': 0.0, 'accessibility': 0.1},
      {'activity': 'Donate blood at a nearby donation center', 'type': 'charity', 'participants': 1, 'price': 0.0, 'accessibility': 0.2},
      {'activity': 'Write letters to elderly people in care homes', 'type': 'charity', 'participants': 1, 'price': 0.0, 'accessibility': 0.0},
      {'activity': 'Fundraise for a cause you care about', 'type': 'charity', 'participants': 2, 'price': 0.0, 'accessibility': 0.0},
    ],
  };

  static final _random = Random();

  /// Returns a shuffled fallback list for the given type
  static List<BoredActivity> _getFallbackActivities(String? type) {
    final key = (type == null || type.isEmpty || type == 'all') ? 'all' : type;
    final raw = _fallbackActivities[key] ?? _fallbackActivities['all']!;
    final shuffled = List<Map<String, dynamic>>.from(raw)..shuffle(_random);
    return shuffled.map((e) => BoredActivity.fromJson(e)).toList();
  }

  /// Tries live API first; falls back to local data on any error.
  static Future<List<BoredActivity>> fetchActivities({String? type}) async {
    try {
      final uri = (type == null || type.isEmpty || type == 'all')
          ? Uri.parse('https://bored-api.appbrewery.com/random')
          : Uri.parse('https://bored-api.appbrewery.com/filter?type=$type');

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // /random returns a single object; /filter returns a list
        if (body is List) {
          final live = body
              .map((e) => BoredActivity.fromJson(e as Map<String, dynamic>))
              .toList();
          if (live.isNotEmpty) return live;
        } else if (body is Map<String, dynamic>) {
          // single random result — merge with fallback for richer list
          final singleLive = BoredActivity.fromJson(body);
          final fallback = _getFallbackActivities(type);
          return [singleLive, ...fallback.take(14)];
        }
      }
    } catch (_) {
      // API down or timeout — silently fall through to fallback
    }

    // Always return local curated data if API fails
    return _getFallbackActivities(type);
  }

  /// Fetches a motivational quote. Falls back to a curated local quote.
  static Future<Quote> fetchQuote() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.quotable.io/random'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return Quote.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (_) {}

    // Fallback quotes
    final fallbackQuotes = [
      Quote(content: 'The secret of getting ahead is getting started.', author: 'Mark Twain'),
      Quote(content: 'You don\'t have to be great to start, but you have to start to be great.', author: 'Zig Ziglar'),
      Quote(content: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb'),
      Quote(content: 'It always seems impossible until it\'s done.', author: 'Nelson Mandela'),
      Quote(content: 'Do something today that your future self will thank you for.', author: 'Sean Patrick Flanery'),
      Quote(content: 'Small steps in the right direction can turn out to be the biggest step of your life.', author: 'Unknown'),
    ];
    return fallbackQuotes[_random.nextInt(fallbackQuotes.length)];
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
