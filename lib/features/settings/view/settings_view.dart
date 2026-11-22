import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/core/services/app_settings_service.dart';
import 'package:wrist_sync/core/widgets/app_card.dart';
import 'package:wrist_sync/core/widgets/app_header.dart';
import 'package:wrist_sync/features/home/widgets/app_bottom_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<AppSettingsService>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppHeader(title: 'Settings'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text(
              'Make WristSync yours',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how the app looks on your device.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: HomeDesign.cyan.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.palette_outlined,
                          color: theme.brightness == Brightness.dark
                              ? HomeDesign.cyan
                              : HomeDesign.teal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Appearance', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('System', maxLines: 1, softWrap: false),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Light', maxLines: 1, softWrap: false),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Dark', maxLines: 1, softWrap: false),
                        ),
                      ],
                      selected: {settings.themeMode.value},
                      onSelectionChanged: (selection) =>
                          settings.setThemeMode(selection.first),
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 8),
                        ),
                        textStyle: WidgetStatePropertyAll(
                          theme.textTheme.labelLarge?.copyWith(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'System follows your device appearance setting.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomBar(selectedIndex: 3),
    );
  }
}
