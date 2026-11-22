import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/core/services/ble_service.dart';
import 'package:wrist_sync/core/widgets/app_button.dart';
import 'package:wrist_sync/core/widgets/app_card.dart';
import 'package:wrist_sync/core/widgets/app_header.dart';
import 'package:wrist_sync/features/home/widgets/app_bottom_bar.dart';
import 'package:wrist_sync/features/home/widgets/status_pill.dart';
import 'package:wrist_sync/routes/app_routes.dart';

class MyWatchesView extends StatelessWidget {
  const MyWatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    final bleService = Get.find<BleService>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppHeader(title: 'My Watches'),
      body: SafeArea(
        child: Obx(() {
          final device = bleService.connectedDevice.value;
          final isConnected =
              bleService.connectionState.value ==
              BluetoothConnectionState.connected;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your collection',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage watches connected with WristSync.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                if (device == null || !isConnected)
                  _EmptyWatchesState(
                    onAddWatch: () => Get.toNamed(AppRoutes.selection),
                  )
                else
                  AppCard(
                    onTap: () => Get.toNamed(AppRoutes.deviceInfo),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: HomeDesign.buttonGradient,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.watch_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _deviceName(device),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              const StatusPill(label: 'Connected'),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                if (device != null && isConnected) ...[
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'View watch details',
                    onPressed: () => Get.toNamed(AppRoutes.deviceInfo),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const AppBottomBar(selectedIndex: 2),
    );
  }

  String _deviceName(BluetoothDevice device) {
    if (device.platformName.isNotEmpty) return device.platformName;
    if (device.advName.isNotEmpty) return device.advName;
    return 'Connected watch';
  }
}

class _EmptyWatchesState extends StatelessWidget {
  const _EmptyWatchesState({required this.onAddWatch});

  final VoidCallback onAddWatch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: HomeDesign.cyan.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.watch_off_rounded,
              color: theme.brightness == Brightness.dark
                  ? HomeDesign.cyan
                  : HomeDesign.teal,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No watches yet',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Pair a compatible Bluetooth watch and it will appear here.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AppButton(text: 'Add a watch', onPressed: onAddWatch),
        ],
      ),
    );
  }
}
