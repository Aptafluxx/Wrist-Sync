import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/features/device_info/controller/device_info_controller.dart';
import 'package:wrist_sync/routes/app_routes.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_icon_badge.dart';
import '../../../core/widgets/app_button.dart';

class DeviceInfoView extends GetView<DeviceInfoController> {
  const DeviceInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final device = controller.bleService.connectedDevice.value;

    if (device == null) {
      return Scaffold(
        appBar: const AppHeader(title: 'Device Details'),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.watch_off_rounded,
                    size: 56,
                    color: theme.brightness == Brightness.dark
                        ? HomeDesign.cyan
                        : HomeDesign.teal,
                  ),
                  const SizedBox(height: 16),
                  Text('No watch connected', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Connect a watch to view its details.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    text: 'Find a watch',
                    onPressed: () => Get.toNamed(AppRoutes.selection),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final deviceName = device.platformName.isNotEmpty
        ? device.platformName
        : (device.advName.isNotEmpty ? device.advName : 'Unknown Watch');

    return Scaffold(
      appBar: const AppHeader(title: 'Device Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/app_logo.png',
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(deviceName, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 12),

                    // Consumer Section: Clean Status and Battery Badges
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _buildStatusBadge(context),
                        _buildBatteryBadge(context),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Technical Section: Collapsible Diagnostics for the Senior Devs
                    AppCard(
                      padding: EdgeInsets.zero,
                      child: Theme(
                        // Removes the default border lines inside the ExpansionTile
                        data: theme.copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(
                            'System Diagnostics',
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            'Hardware metrics for developers',
                            style: theme.textTheme.bodySmall,
                          ),
                          leading: AppIconBadge(
                            icon: Icons.memory,
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            iconColor: theme.colorScheme.primary,
                          ),
                          childrenPadding: const EdgeInsets.all(20)
                              .copyWith(top: 0),
                          children: [
                            Divider(
                              height: 1,
                              color: theme.dividerColor.withValues(alpha: 0.1),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              context,
                              'MAC Address',
                              device.remoteId.str,
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => _buildInfoRow(
                                context,
                                'MTU Size',
                                controller.mtuSize.value == 0
                                    ? 'Reading...'
                                    : '${controller.mtuSize.value} bytes',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => _buildInfoRow(
                                context,
                                'GATT Services',
                                controller.isDiscovering.value
                                    ? 'Discovering...'
                                    : '${controller.services.length} services',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AppButton(
                text: 'Disconnect Watch',
                isOutlined: true,
                onPressed: controller.disconnect,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.brightness == Brightness.dark
        ? const Color(0xFF8BE0B1)
        : const Color(0xFF187A4A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bluetooth_connected, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            'Connected',
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryBadge(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface.withValues(alpha: 0.72);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.battery_unknown_rounded, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            'Battery unavailable',
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.disabledColor,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
