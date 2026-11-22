import 'package:flutter/material.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/features/home/widgets/press_scale.dart';

class HelpTile extends StatelessWidget {
  const HelpTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PressScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF1B3443), Color(0xFF282D49)],
                )
              : HomeDesign.helpGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: HomeDesign.cardShadows,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF294B5A)
                    : const Color(0xFFD8F5F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent_rounded,
                color: isDark ? HomeDesign.cyan : const Color(0xFF128A9B),
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need help connecting?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Your setup guide is just a tap away.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}
