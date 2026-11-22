import 'package:flutter/material.dart';
import 'package:wrist_sync/core/constants/home_design.dart';
import 'package:wrist_sync/features/home/widgets/press_scale.dart';

class HeroCard extends StatefulWidget {
  const HeroCard({super.key, required this.onConnect});

  final VoidCallback onConnect;

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _floatController.stop();
    } else if (!_floatController.isAnimating) {
      _floatController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final compact = MediaQuery.sizeOf(context).width < 380;

    return Container(
      height: compact ? 264 : 252,
      decoration: BoxDecoration(
        gradient: HomeDesign.heroGradient,
        borderRadius: BorderRadius.circular(HomeDesign.cardRadius),
        boxShadow: HomeDesign.heroShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(HomeDesign.cardRadius),
        child: Stack(
          children: [
            Positioned(
              right: 2,
              top: 4,
              width: 196,
              height: 196,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      HomeDesign.cyan.withValues(alpha: 0.32),
                      HomeDesign.cyan.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.52, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              right: compact ? 6 : 34,
              top: compact ? 48 : 32,
              width: compact ? 108 : 138,
              height: compact ? 116 : 138,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final phase = _floatController.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var index = 0; index < 3; index++)
                        _RippleRing(phase: (phase + index / 3) % 1),
                      Transform.translate(
                        offset: Offset(0, -4 + phase * 8),
                        child: child,
                      ),
                    ],
                  );
                },
                child: CustomPaint(
                  size: compact ? const Size(72, 116) : const Size(104, 170),
                  painter: const WatchIllustrationPainter(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: HomeDesign.cyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'YOUR NEXT CONNECTION',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: HomeDesign.cyan,
                            letterSpacing: compact ? 0.8 : 1.15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: compact ? 92 : 112),
                    child: Text(
                      'Your watch,\nin sync.',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontSize: compact ? 22 : 26,
                        height: 1.12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(right: compact ? 92 : 110),
                    child: Text(
                      'Pair your watch and make every moment yours.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PressScale(
                    onTap: widget.onConnect,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: HomeDesign.buttonGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: HomeDesign.cyan.withValues(alpha: 0.28),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Connect Now',
                              style: textTheme.labelLarge?.copyWith(
                                color: HomeDesign.navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: HomeDesign.navy,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RippleRing extends StatelessWidget {
  const _RippleRing({required this.phase});

  final double phase;

  @override
  Widget build(BuildContext context) {
    final scale = 0.62 + phase * 0.42;
    final opacity = (1 - phase) * 0.42;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 114,
        height: 114,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: HomeDesign.cyan.withValues(alpha: opacity),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class WatchIllustrationPainter extends CustomPainter {
  const WatchIllustrationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final strapWidth = size.width * 0.42;
    final strapRect = Rect.fromCenter(
      center: Offset(centerX, size.height / 2),
      width: strapWidth,
      height: size.height * 0.98,
    );
    final strapPaint = Paint()..color = const Color(0xFF9BAEB8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(strapRect, Radius.circular(strapWidth / 2)),
      strapPaint,
    );
    final strapInset = strapRect.deflate(4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(strapInset, Radius.circular(strapWidth / 2)),
      Paint()..color = const Color(0xFF364B55),
    );

    final caseRect = Rect.fromCenter(
      center: Offset(centerX, size.height * 0.49),
      width: size.width * 0.82,
      height: size.height * 0.48,
    );
    final caseRRect = RRect.fromRectAndRadius(
      caseRect,
      const Radius.circular(24),
    );
    canvas.drawRRect(caseRRect, Paint()..color = const Color(0xFFE4F3F4));
    canvas.drawRRect(
      RRect.fromRectAndRadius(caseRect.deflate(3), const Radius.circular(21)),
      Paint()..color = const Color(0xFF122631),
    );

    final faceRect = caseRect.deflate(9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(faceRect, const Radius.circular(15)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF173844), Color(0xFF091720)],
        ).createShader(faceRect),
    );

    final center = faceRect.center;
    final radius = faceRect.width * 0.31;
    final ringPaint = Paint()
      ..color = HomeDesign.cyan.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawCircle(center, radius, ringPaint);
    canvas.drawLine(
      center,
      center + Offset(0, -radius * 0.68),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      center,
      center + Offset(radius * 0.58, radius * 0.1),
      Paint()
        ..color = HomeDesign.cyan
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 2.4, Paint()..color = HomeDesign.cyan);
    canvas.drawCircle(
      Offset(centerX, caseRect.top + 10),
      1.5,
      Paint()..color = HomeDesign.cyan.withValues(alpha: 0.7),
    );
    canvas.drawCircle(
      Offset(caseRect.right + 4, caseRect.center.dy),
      4,
      Paint()..color = const Color(0xFFB8D0D6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
