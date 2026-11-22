import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/core/widgets/app_icon_badge.dart';
import 'package:wrist_sync/core/widgets/app_button.dart';
import 'package:wrist_sync/core/widgets/app_card.dart';
import 'package:wrist_sync/core/widgets/app_header.dart';
import 'package:wrist_sync/routes/app_routes.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  static const _steps = [
    _SetupStep(
      title: 'Get your watch ready',
      detail: 'Charge it, turn it on, and keep it close to your phone.',
      icon: Icons.watch_rounded,
    ),
    _SetupStep(
      title: 'Enable Bluetooth',
      detail: 'Turn on Bluetooth on your phone and allow nearby-device access.',
      icon: Icons.bluetooth_rounded,
    ),
    _SetupStep(
      title: 'Scan and connect',
      detail:
          'Choose a watch type, select your watch, and wait for it to pair.',
      icon: Icons.radar_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppHeader(title: 'Setup Guide'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'Let’s get connected',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A few quick checks make pairing easier.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            for (var index = 0; index < _steps.length; index++) ...[
              _GuideStepCard(number: index + 1, step: _steps[index]),
              if (index != _steps.length - 1) const SizedBox(height: 12),
            ],
            const SizedBox(height: 20),
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Having trouble?', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'If access was denied, enable Bluetooth and nearby-device permissions in your phone settings, then try again.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final opened = await openAppSettings();
                      if (!opened && context.mounted) {
                        Get.snackbar(
                          'Settings unavailable',
                          'Open WristSync permissions from your device settings.',
                        );
                      }
                    },
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Open app settings'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'Add a watch',
              onPressed: () => Get.toNamed(AppRoutes.selection),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStepCard extends StatelessWidget {
  const _GuideStepCard({required this.number, required this.step});

  final int number;
  final _SetupStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AppIconBadge(
                icon: step.icon,
                backgroundColor: HomeDesign.cyan.withValues(alpha: 0.14),
                iconColor: theme.brightness == Brightness.dark
                    ? HomeDesign.cyan
                    : HomeDesign.teal,
              ),
              Positioned(
                top: -5,
                right: -5,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: HomeDesign.teal,
                  child: Text(
                    '$number',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(step.detail, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupStep {
  const _SetupStep({
    required this.title,
    required this.detail,
    required this.icon,
  });

  final String title;
  final String detail;
  final IconData icon;
}
