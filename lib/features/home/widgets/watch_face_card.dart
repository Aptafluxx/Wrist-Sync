import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/features/home/widgets/press_scale.dart';

enum WatchFaceStyle { analog, digital, minimal }

class WatchFaceData {
  const WatchFaceData({
    required this.name,
    required this.style,
    required this.background,
    required this.accent,
  });

  final String name;
  final WatchFaceStyle style;
  final Color background;
  final Color accent;
}

class WatchFaceCard extends StatelessWidget {
  const WatchFaceCard({super.key, required this.face, required this.onTap});

  final WatchFaceData face;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PressScale(
      onTap: onTap,
      child: SizedBox(
        width: 108,
        child: Column(
          children: [
            Container(
              width: 108,
              height: 116,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                boxShadow: HomeDesign.cardShadows,
              ),
              child: Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: face.accent.withValues(alpha: 0.22),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: WatchFacePainter(face),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              face.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WatchFacePainter extends CustomPainter {
  const WatchFacePainter(this.face);

  final WatchFaceData face;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(center, radius, Paint()..color = face.background);
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..color = face.accent.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    switch (face.style) {
      case WatchFaceStyle.analog:
        _paintAnalog(canvas, center, radius);
        break;
      case WatchFaceStyle.digital:
        _paintDigital(canvas, center, radius);
        break;
      case WatchFaceStyle.minimal:
        _paintMinimal(canvas, center, radius);
        break;
    }
  }

  void _paintAnalog(Canvas canvas, Offset center, double radius) {
    for (var index = 0; index < 12; index++) {
      final angle = index * 3.141592653589793 / 6;
      final inner = radius * 0.78;
      final outer = radius * 0.88;
      final paint = Paint()
        ..color = face.accent.withValues(alpha: index.isEven ? 0.9 : 0.55)
        ..strokeWidth = index.isEven ? 1.6 : 1
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        center + Offset(inner * math.cos(angle), inner * math.sin(angle)),
        center + Offset(outer * math.cos(angle), outer * math.sin(angle)),
        paint,
      );
    }
    canvas.drawLine(
      center,
      center + Offset(-radius * 0.08, -radius * 0.48),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      center,
      center + Offset(radius * 0.4, radius * 0.1),
      Paint()
        ..color = face.accent
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 2.3, Paint()..color = face.accent);
  }

  void _paintDigital(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '10:08',
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.43,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: radius * 1.7);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.38, center.dy + radius * 0.28),
      Offset(center.dx + radius * 0.38, center.dy + radius * 0.28),
      Paint()
        ..color = face.accent
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintMinimal(Canvas canvas, Offset center, double radius) {
    final arcPaint = Paint()
      ..color = face.accent.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      -1.5,
      4.2,
      false,
      arcPaint,
    );
    canvas.drawCircle(
      center,
      radius * 0.26,
      Paint()..color = face.accent.withValues(alpha: 0.16),
    );
    canvas.drawCircle(center, radius * 0.08, Paint()..color = face.accent);
  }

  @override
  bool shouldRepaint(covariant WatchFacePainter oldDelegate) =>
      oldDelegate.face != face;
}
