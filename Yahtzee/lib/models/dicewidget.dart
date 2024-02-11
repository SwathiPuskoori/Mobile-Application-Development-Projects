import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int value;
  final VoidCallback onTap;
  final bool isHeld;
  const DiceWidget({
    Key? key,
    required this.value,
    required this.onTap,
    this.isHeld = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border:
              Border.all(color: isHeld ? Colors.green : Colors.black, width: 2),
        ),
        child: Center(
          child: value > 0
              ? Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
