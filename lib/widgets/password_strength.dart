import 'package:flutter/material.dart';

class PasswordStrength extends StatelessWidget {
  final String password;
  const PasswordStrength({super.key, required this.password});

  int _score(String pw) {
    int score = 0;
    if (pw.length >= 6) score++;
    if (pw.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(pw)) score++;
    if (RegExp(r'[0-9]').hasMatch(pw)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(pw)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final s = _score(password);
    final percent = (s / 5);
    String label;
    if (s <= 1) label = 'Weak';
    else if (s == 2) label = 'Fair';
    else if (s == 3) label = 'Good';
    else if (s == 4) label = 'Strong';
    else label = 'Excellent';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: percent,
          minHeight: 8,
          backgroundColor: Colors.grey[200],
          color: Colors.deepPurple,
        ),
        const SizedBox(height: 6),
        Text('$label ${(percent * 100).round()}%'),
      ],
    );
  }
}
