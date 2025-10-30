import 'package:flutter/material.dart';

class AvatarSelector extends StatefulWidget {
  final Function(int) onSelected;
  final int initialIndex;
  const AvatarSelector({super.key, required this.onSelected, this.initialIndex = 0});

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late int _selected;
  final List<IconData> _avatars = [
    Icons.person, Icons.pets, Icons.face, Icons.android, Icons.star
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_avatars.length, (i) {
        final selected = i == _selected;
        return GestureDetector(
          onTap: () {
            setState(() => _selected = i);
            widget.onSelected(i);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected ? Colors.deepPurple[100] : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? Colors.deepPurple : Colors.transparent,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: selected ? Colors.deepPurple : Colors.grey[300],
              child: Icon(_avatars[i], color: Colors.white),
            ),
          ),
        );
      }),
    );
  }
}
