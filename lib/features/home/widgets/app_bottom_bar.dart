import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrist_sync/features/home/widgets/press_scale.dart';
import 'package:wrist_sync/routes/app_routes.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key, required this.selectedIndex});

  final int selectedIndex;

  static const _destinations = [
    _BottomDestination(label: 'Home', icon: Icons.home_rounded),
    _BottomDestination(label: 'Faces', icon: Icons.watch_rounded),
    _BottomDestination(label: 'Devices', icon: Icons.bluetooth_rounded),
    _BottomDestination(label: 'Settings', icon: Icons.tune_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
        child: SizedBox(
          height: 66,
          child: Center(
            child: Container(
              key: const ValueKey('home-bottom-nav-pill'),
              constraints: const BoxConstraints(maxWidth: 560),
              height: 66,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.28 : 0.1,
                    ),
                    blurRadius: 28,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (var index = 0; index < _destinations.length; index++)
                    Expanded(
                      child: _BottomBarItem(
                        destination: _destinations[index],
                        selected: index == selectedIndex,
                        onTap: () => _activateDestination(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _activateDestination(int index) {
    final destination = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.watchFaces,
      2 => AppRoutes.myWatches,
      3 => AppRoutes.settings,
      _ => AppRoutes.home,
    };
    if (Get.currentRoute != destination) Get.offAllNamed(destination);
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _BottomDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.brightness == Brightness.dark
        ? const Color(0xFF53E3F3)
        : const Color(0xFF087F8C);
    final idleColor = theme.colorScheme.onSurface.withValues(alpha: 0.52);

    return PressScale(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            destination.icon,
            size: 21,
            color: selected ? selectedColor : idleColor,
          ),
          const SizedBox(height: 4),
          Text(
            destination.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? selectedColor : idleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomDestination {
  const _BottomDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
