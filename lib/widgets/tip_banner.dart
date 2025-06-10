import 'package:flutter/material.dart';

class TipBanner extends StatelessWidget {
  const TipBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '💡 Tip: Stay hydrated throughout the day!',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
