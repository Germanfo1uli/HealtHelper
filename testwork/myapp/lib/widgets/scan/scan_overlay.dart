import 'package:flutter/material.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    super.key,
    this.cutOutSize = 240,
    this.borderRadius = 24,
    this.borderWidth = 3,
    this.scrimColor = const Color(0xB0000000),
    this.borderColor = Colors.white,
  });

  final double cutOutSize;
  final double borderRadius;
  final double borderWidth;
  final Color scrimColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScanOverlayPainter(
        cutOutSize: cutOutSize,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        scrimColor: scrimColor,
        borderColor: borderColor,
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  _ScanOverlayPainter({
    required this.cutOutSize,
    required this.borderRadius,
    required this.borderWidth,
    required this.scrimColor,
    required this.borderColor,
  });

  final double cutOutSize;
  final double borderRadius;
  final double borderWidth;
  final Color scrimColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = scrimColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final center = size.center(const Offset(0, -32));
    final cutOutRect = Rect.fromCenter(
      center: center,
      width: cutOutSize,
      height: cutOutSize,
    );
    final cutOutRRect = RRect.fromRectAndRadius(
      cutOutRect,
      Radius.circular(borderRadius),
    );

    final overlayPath = Path()..addRect(Offset.zero & size);
    final cutOutPath = Path()..addRRect(cutOutRRect);
    final finalPath = Path.combine(
      PathOperation.difference,
      overlayPath,
      cutOutPath,
    );

    canvas.drawPath(finalPath, overlayPaint);
    canvas.drawRRect(cutOutRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanOverlayPainter oldDelegate) {
    return oldDelegate.cutOutSize != cutOutSize ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.scrimColor != scrimColor ||
        oldDelegate.borderColor != borderColor;
  }
}
