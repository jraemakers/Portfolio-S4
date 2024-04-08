import 'package:flutter/material.dart';
import 'dart:math' as math;

class PizzaPainter extends CustomPainter {
  final Map<String, int> ingredients;

  PizzaPainter({required this.ingredients});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    double startAngle = 0.0;
    final total =
        ingredients.values.fold(0, (int sum, int value) => sum + value);

    ingredients.forEach((ingredient, value) {
      final sweepAngle = (value / total) * 2 * math.pi;
      paint.color = Colors.primaries[
          ingredients.keys.toList().indexOf(ingredient) %
              Colors.primaries.length];

      canvas.drawArc(
          Rect.fromCircle(
              center: size.center(Offset.zero), radius: size.width / 2),
          startAngle,
          sweepAngle,
          true,
          paint);

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
