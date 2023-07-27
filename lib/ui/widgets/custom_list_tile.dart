import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/data/models/character.dart';

class CustomListTile extends StatelessWidget {
  final Results result;
  const CustomListTile({
    super.key,
    required this.result
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        result.name,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
