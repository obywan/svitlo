import 'package:flutter/material.dart';

class ActiveDot extends StatelessWidget {
  final double size;
  final bool active;
  const ActiveDot({
    Key? key,
    required this.size,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: active ? Colors.amber : Colors.black,
        border: Border.all(),
      ),
    );
  }
}
