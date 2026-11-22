import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:wrist_sync/core/services/ble_service.dart';
import 'package:wrist_sync/features/home/controller/home_controller.dart';
import 'package:wrist_sync/features/home/widgets/app_bottom_bar.dart';
import 'package:wrist_sync/features/home/widgets/feature_tile.dart';
import 'package:wrist_sync/features/home/widgets/help_tile.dart';
import 'package:wrist_sync/features/home/widgets/hero_card.dart';
import 'package:wrist_sync/features/home/widgets/quick_action_card.dart';
import 'package:wrist_sync/features/home/widgets/status_pill.dart';
import 'package:wrist_sync/features/home/widgets/watch_face_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _HomeBody(controller: controller)),
      bottomNavigationBar: const AppBottomBar(selectedIndex: 0),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody({required this.controller});

  final HomeController controller;

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animatedSection(start: 0, end: 0.38, child: const _HomeHeader()),
              const SizedBox(height: 24),
              _animatedSection(
                start: 0.08,
                end: 0.5,
                child: HeroCard(onConnect: controller.navigateToSelection),
              ),
              const SizedBox(height: 24),
              _animatedSection(
                start: 0.16,
                end: 0.58,
                child: Row(
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        title: 'My Watches',
                        detail: 'View and manage',
                        badge: '0 devices',
                        icon: Icons.watch_rounded,
                        colors: const [Color(0xFF16B8D4), Color(0xFF1687A6)],
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: QuickActionCard(
                        title: 'Watch Faces',
                        detail: 'Make it yours',
                        badge: 'New',
                        icon: Icons.palette_rounded,
                        colors: const [Color(0xFF8974F8), Color(0xFF6251C9)],
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _animatedSection(
                start: 0.24,
                end: 0.68,
                child: _FeaturedFacesSection(onSeeAll: () {}),
              ),
              const SizedBox(height: 28),
              _animatedSection(
                start: 0.32,
                end: 0.78,
                child: const _FeaturesSection(),
              ),
              const SizedBox(height: 24),
              _animatedSection(
                start: 0.4,
                end: 0.9,
                child: HelpTile(onTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedSection({
    required double start,
    required double end,
    required Widget child,
  }) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: Tween<double>(begin: 0.65, end: 1).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bleService = Get.isRegistered<BleService>()
        ? Get.find<BleService>()
        : null;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting(), style: textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                'WristSync',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 10),
              if (bleService == null)
                const StatusPill(label: 'No watch connected')
              else
                Obx(() {
                  final connected =
                      bleService.connectionState.value ==
                      BluetoothConnectionState.connected;
                  return StatusPill(
                    label: connected ? 'Watch connected' : 'No watch connected',
                  );
                }),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF55E7F5), Color(0xFF7D79F6)],
            ),
          ),
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.surface,
            child: ClipOval(
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.watch_rounded, color: theme.colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _FeaturedFacesSection extends StatelessWidget {
  const _FeaturedFacesSection({required this.onSeeAll});

  final VoidCallback onSeeAll;

  static const _faces = [
    WatchFaceData(
      name: 'Midnight',
      style: WatchFaceStyle.analog,
      background: Color(0xFF101D32),
      accent: Color(0xFF53E3F3),
    ),
    WatchFaceData(
      name: 'Aurora',
      style: WatchFaceStyle.digital,
      background: Color(0xFF252052),
      accent: Color(0xFFB6A8FF),
    ),
    WatchFaceData(
      name: 'Minimal',
      style: WatchFaceStyle.minimal,
      background: Color(0xFF183D3E),
      accent: Color(0xFF8BF0D0),
    ),
    WatchFaceData(
      name: 'Pulse',
      style: WatchFaceStyle.analog,
      background: Color(0xFF432C42),
      accent: Color(0xFFFF9DAD),
    ),
    WatchFaceData(
      name: 'Orbit',
      style: WatchFaceStyle.digital,
      background: Color(0xFF26384B),
      accent: Color(0xFFFFD27A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Featured watch faces', style: textTheme.titleLarge),
            ),
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF08AFC3),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 162,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _faces.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                WatchFaceCard(face: _faces[index], onTap: onSeeAll),
          ),
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  static const _features = [
    _FeatureData(
      title: 'Easy Pairing',
      description: 'Connect in a few taps',
      icon: Icons.bluetooth_rounded,
      color: Color(0xFF13BFD2),
    ),
    _FeatureData(
      title: 'Custom Faces',
      description: 'A look that feels yours',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF8B78F6),
    ),
    _FeatureData(
      title: 'Health & Battery Sync',
      description: 'Your watch, in sync',
      icon: Icons.favorite_rounded,
      color: Color(0xFFFF8B83),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Made for your rhythm', style: textTheme.titleLarge),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 520 ? 3 : 2;
            final tileWidth =
                (constraints.maxWidth - (columns - 1) * 12) / columns;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final feature in _features)
                  SizedBox(
                    width: tileWidth,
                    child: FeatureTile(
                      title: feature.title,
                      description: feature.description,
                      icon: feature.icon,
                      color: feature.color,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
