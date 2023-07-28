import 'package:flutter/material.dart';

enum LiveState { alive, dead, unknown } // Статусы персонажа

class CharacterStatus extends StatelessWidget {
  final LiveState liveState;

  const CharacterStatus({super.key, required this.liveState});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 11,
          color: liveState == LiveState.alive
              ? Colors.greenAccent[400]
              : liveState == LiveState.dead
                  ? Colors.red
                  : Colors.white,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          liveState == LiveState.dead
              ? "Dead"
              : liveState == LiveState.alive
              ? "Alive"
              : "Unknown",
        )
      ],
    );
  }
}
