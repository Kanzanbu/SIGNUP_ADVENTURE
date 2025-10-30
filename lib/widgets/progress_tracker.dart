import 'package:flutter/material.dart';

class ProgressTracker extends StatelessWidget {
  final double progress;
  const ProgressTracker({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    String message = '';
    if (pct >= 25 && pct < 50) message = 'Great start!';
    if (pct >= 50 && pct < 75) message = 'Halfway there!';
    if (pct >= 75 && pct < 100) message = 'Almost done!';
    if (pct >= 100) message = 'Ready for adventure!';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 14,
              width: MediaQuery.of(context).size.width * progress,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$pct% Complete'),
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
