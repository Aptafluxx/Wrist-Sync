import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wrist_sync/features/scan/controller/scan_controller.dart';
import 'package:wrist_sync/core/services/ble_service.dart';
import 'package:wrist_sync/routes/app_routes.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_icon_badge.dart';
import '../../../core/widgets/app_button.dart';

import 'package:wrist_sync/core/constants/home_design.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppHeader(title: 'Add New Watch'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AppCard(
                child: Row(
                  children: [
                    Obx(
                      () => AppIconBadge(
                        icon: controller.bleService.isScanning.value
                            ? Icons.bluetooth_searching
                            : Icons.bluetooth,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Devices',
                            style: theme.textTheme.titleMedium,
                          ),
                          Obx(
                            () => Text(
                              controller.bleService.isScanning.value
                                  ? 'Scanning for nearby watches...'
                                  : controller.bleService.scanIssue.value ==
                                        null
                                  ? 'Ready to find a nearby watch.'
                                  : 'Check the connection requirements below.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final issue = controller.bleService.scanIssue.value;
                if (issue != null) return _buildIssueState(context, issue);
                if (controller.bleService.scanResults.isEmpty) {
                  if (controller.bleService.isScanning.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildEmptyState(context);
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshScan,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: controller.bleService.scanResults.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final result = controller.bleService.scanResults[index];
                      return _buildDeviceTile(context, result);
                    },
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Obx(
                () => AppButton(
                  text: controller.bleService.isScanning.value
                      ? 'Scanning...'
                      : 'Rescan',
                  onPressed: controller.refreshScan,
                  isLoading: controller.bleService.isScanning.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: HomeDesign.cyan.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.watch_off_outlined,
              size: 38,
              color: theme.brightness == Brightness.dark
                  ? HomeDesign.cyan
                  : HomeDesign.teal,
            ),
          ),
          const SizedBox(height: 16),
          Text('No watches found', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Turn on your watch and keep it nearby,\nthen scan again.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildIssueState(BuildContext context, BleScanIssue issue) {
    final theme = Theme.of(context);
    final details = switch (issue) {
      BleScanIssue.permissionsDenied => (
        Icons.location_disabled_rounded,
        'Permission needed',
        'Allow Nearby devices and Bluetooth access for WristSync in app settings.',
      ),
      BleScanIssue.bluetoothOff => (
        Icons.bluetooth_disabled_rounded,
        'Bluetooth is turned off',
        'Turn on Bluetooth in your phone settings, then try scanning again.',
      ),
      BleScanIssue.scanFailed => (
        Icons.error_outline_rounded,
        'Could not start scanning',
        'Check that Bluetooth is available, then try again.',
      ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(details.$1, size: 54, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              details.$2,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              details.$3,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (issue == BleScanIssue.permissionsDenied) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.help),
                child: const Text('Open setup guide'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTile(BuildContext context, ScanResult result) {
    final theme = Theme.of(context);
    final device = result.device;
    final deviceName = device.platformName.isNotEmpty
        ? device.platformName
        : (device.advName.isNotEmpty ? device.advName : 'Unknown Device');

    return AppCard(
      onTap: () => controller.connectToDevice(device),
      child: Row(
        children: [
          AppIconBadge(
            icon: Icons.watch,
            backgroundColor: theme.colorScheme.primary,
            iconColor: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deviceName, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(device.remoteId.str, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${result.rssi} dBm',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: result.rssi > -60
                      ? Colors.green
                      : (result.rssi > -80 ? Colors.orange : Colors.red),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.signal_cellular_alt,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
