import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';

class CircularProgressSection extends StatelessWidget {
  const CircularProgressSection({super.key});

  Future<int> _fetchSteps() async {
    final types = [HealthDataType.STEPS];
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final health = Health();
    final authorized = await health.requestAuthorization(types);

    if (authorized) {
      final data = await health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: types,
      );
      return data.fold<int>(0, (sum, d) => sum + (d.value as int? ?? 0));
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    const int stepGoal = 10000;

    return FutureBuilder<int>(
      future: _fetchSteps(),
      builder: (context, snapshot) {
        final steps = snapshot.data ?? 0;
        final percent = (steps / stepGoal).clamp(0.0, 1.0);

        return CircularPercentIndicator(
          radius: 90.0,
          lineWidth: 12.0,
          animation: true,
          percent: percent,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Steps', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text('$steps', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.blue,
          backgroundColor: Colors.grey.shade300,
        );
      },
    );
  }
}
