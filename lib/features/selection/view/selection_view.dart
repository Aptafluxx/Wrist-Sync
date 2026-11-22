import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/core/widgets/app_header.dart';
import 'package:wrist_sync/features/selection/controller/selection_controller.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_icon_badge.dart';

class SelectionView extends GetView<SelectionController> {
  const SelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: const AppHeader(title: 'Choose Your Watch'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start with your watch type',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We’ll scan for nearby Bluetooth watches next.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.watch_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text('Choose a category', style: textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDeviceRow(
                      context,
                      icon: Icons.watch_outlined,
                      title: 'WristSync & Huawei',
                      subtitle: 'Look for WristSync watches and compatible Huawei devices.',
                      onTap: () => controller.selectDeviceType('smart_watch'),
                    ),
                    const SizedBox(height: 12),
                    _buildDeviceRow(
                      context,
                      icon: Icons.watch_later_outlined,
                      title: 'Other Bluetooth watches',
                      subtitle:
                          'Scan for compatible watches from other brands.',
                      onTap: () => controller.selectDeviceType('other_watch'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Both options use the same nearby-device scan. Choose the closest match for setup guidance.',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AppCard(
      onTap: onTap,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconBadge(
                icon: icon,
                backgroundColor: HomeDesign.cyan.withValues(alpha: 0.15),
                iconColor: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: textTheme.titleMedium)),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          const SizedBox(height: 12),
          Text(subtitle, style: textTheme.bodyMedium?.copyWith(height: 1.3)),
        ],
      ),
    );
  }
}
