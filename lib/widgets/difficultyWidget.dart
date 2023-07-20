// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DifficultyStarsWidget extends StatelessWidget {
  final int difficulty;
  const DifficultyStarsWidget({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: (difficulty >= 1) ? Colors.blue : Colors.blue[100],
        ),
        Icon(
          Icons.star,
          color: (difficulty >= 2) ? Colors.blue : Colors.blue[100],
        ),
        Icon(
          Icons.star,
          color: (difficulty >= 3) ? Colors.blue : Colors.blue[100],
        ),
        Icon(
          Icons.star,
          color: (difficulty >= 4) ? Colors.blue : Colors.blue[100],
        ),
        Icon(
          Icons.star,
          color: (difficulty == 5) ? Colors.blue : Colors.blue[100],
        )
      ],
    );
  }
}
