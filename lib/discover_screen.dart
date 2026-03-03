import 'package:flutter/material.dart';
import 'models/bored_activity.dart';
import 'services/api_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  List<BoredActivity> _activities = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'all';
  late AnimationController _shimmerController;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'value': 'all', 'icon': '✨'},
    {'label': 'Education', 'value': 'education', 'icon': '📚'},
    {'label': 'Recreational', 'value': 'recreational', 'icon': '🎮'},
    {'label': 'Social', 'value': 'social', 'icon': '👥'},
    {'label': 'DIY', 'value': 'diy', 'icon': '🔧'},
    {'label': 'Cooking', 'value': 'cooking', 'icon': '🍳'},
    {'label': 'Relaxation', 'value': 'relaxation', 'icon': '🧘'},
    {'label': 'Music', 'value': 'music', 'icon': '🎵'},
    {'label': 'Charity', 'value': 'charity', 'icon': '❤️'},
  ];

  // Color palette per category
  final Map<String, List<Color>> _categoryColors = {
    'education': [const Color(0xFF4776E6), const Color(0xFF8E54E9)],
    'recreational': [const Color(0xFFF7971E), const Color(0xFFFFD200)],
    'social': [const Color(0xFF11998e), const Color(0xFF38ef7d)],
    'diy': [const Color(0xFFc94b4b), const Color(0xFF4b134f)],
    'cooking': [const Color(0xFFFC5C7D), const Color(0xFF6A3093)],
    'relaxation': [const Color(0xFF2193b0), const Color(0xFF6dd5ed)],
    'music': [const Color(0xFF373B44), const Color(0xFF4286f4)],
    'charity': [const Color(0xFFCB356B), const Color(0xFFBD3F32)],
    'busywork': [const Color(0xFF56ab2f), const Color(0xFFa8e063)],
    'all': [const Color(0xFF614385), const Color(0xFF516395)],
  };

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _loadActivities();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await ApiService.fetchActivities(
        type: _selectedCategory == 'all' ? null : _selectedCategory,
      );
      if (mounted) {
        setState(() {
          _activities = data;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    }
  }

  void _onCategorySelected(String value) {
    if (_selectedCategory == value) return;
    setState(() => _selectedCategory = value);
    _loadActivities();
  }

  List<Color> _getColors(String type) {
    return _categoryColors[type.toLowerCase()] ??
        _categoryColors['all']!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Banner
        _buildHeader(isDark),

        // Category Filter Chips
        _buildCategoryChips(isDark),

        const SizedBox(height: 8),

        // Content Area
        Expanded(
          child: _isLoading
              ? _buildShimmerList(isDark)
              : _errorMessage != null
                  ? _buildErrorState()
                  : _activities.isEmpty
                      ? _buildEmptyState()
                      : _buildActivityList(isDark),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1F1F1F), const Color(0xFF2C2C2C)]
              : [const Color(0xFF614385), const Color(0xFF516395)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Activities',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Find something new to do right now',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(bool isDark) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['value'];
          return GestureDetector(
            onTap: () => _onCategorySelected(cat['value'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isSelected
                    ? LinearGradient(
                        colors: _getColors(cat['value'] as String),
                      )
                    : null,
                color: isSelected
                    ? null
                    : (isDark
                        ? const Color(0xFF2C2C2C)
                        : Colors.grey.shade200),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _getColors(cat['value'] as String)
                              .last
                              .withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cat['icon'] as String,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityList(bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadActivities,
      color: const Color(0xFF614385),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          return _ActivityCard(
            activity: _activities[index],
            colors: _getColors(_activities[index].type),
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: 6,
      itemBuilder: (context, index) => _ShimmerCard(
        controller: _shimmerController,
        isDark: isDark,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to Fetch Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Something went wrong. Please try again.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _loadActivities,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🤷', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text(
            'No Activities Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different category',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Activity Card with Glassmorphism Design
// ─────────────────────────────────────────────────────────────
class _ActivityCard extends StatelessWidget {
  final BoredActivity activity;
  final List<Color> colors;
  final int index;

  const _ActivityCard({
    required this.activity,
    required this.colors,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colors[0].withOpacity(isDark ? 0.85 : 0.9),
            colors[1].withOpacity(isDark ? 0.85 : 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative circle
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -10,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      activity.typeLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Activity Title
                  Text(
                    activity.activity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    children: [
                      _statChip(
                        icon: Icons.people_outline_rounded,
                        label:
                            '${activity.participants} ${activity.participants == 1 ? 'person' : 'people'}',
                      ),
                      const SizedBox(width: 10),
                      _statChip(
                        icon: Icons.attach_money_rounded,
                        label: activity.price == 0
                            ? 'Free'
                            : activity.price < 0.3
                                ? 'Low cost'
                                : activity.price < 0.7
                                    ? 'Moderate'
                                    : 'Expensive',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Accessibility Bar
                  Row(
                    children: [
                      const Text(
                        'Ease',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 1.0 - activity.accessibility,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${((1.0 - activity.accessibility) * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shimmer Loading Card
// ─────────────────────────────────────────────────────────────
class _ShimmerCard extends StatelessWidget {
  final AnimationController controller;
  final bool isDark;

  const _ShimmerCard({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: 155,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * controller.value, 0),
              end: Alignment(1.0 + 2.0 * controller.value, 0),
              colors: isDark
                  ? [
                      const Color(0xFF2C2C2C),
                      const Color(0xFF3A3A3A),
                      const Color(0xFF2C2C2C),
                    ]
                  : [
                      Colors.grey.shade200,
                      Colors.grey.shade100,
                      Colors.grey.shade200,
                    ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
