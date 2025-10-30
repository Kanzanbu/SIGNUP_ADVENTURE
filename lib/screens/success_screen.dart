import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class SuccessScreen extends StatefulWidget {
  final String userName;
  final int avatarIndex;
  final List<String> badges;

  const SuccessScreen({
    super.key,
    required this.userName,
    this.avatarIndex = 0,
    this.badges = const [],
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _controller;
  final List<IconData> _avatars = [
    Icons.person, Icons.pets, Icons.face, Icons.android, Icons.star
  ];

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 5));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    _avatars[widget.avatarIndex % _avatars.length],
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Welcome, ${widget.userName}!',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
                const SizedBox(height: 10),
                const Text('Your adventure begins now!',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  children:
                      widget.badges.map((b) => Chip(label: Text(b))).toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _controller.play(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('More Celebration!',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
