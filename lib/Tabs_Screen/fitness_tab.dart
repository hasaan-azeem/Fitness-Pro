// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FitnessTab extends StatefulWidget {
  const FitnessTab({super.key});

  @override
  State<FitnessTab> createState() => _FitnessTabState();
}

class _FitnessTabState extends State<FitnessTab> {
  String greeting = '';

  @override
  void initState() {
    super.initState();
    setGreeting();
  }

  void setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = "Good morning";
    } else if (hour < 17) {
      greeting = "Good afternoon";
    } else {
      greeting = "Good evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$greeting 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _todayWorkoutPlan(isDark),
            const SizedBox(height: 24),
            _weeklyProgress(),
            const SizedBox(height: 24),
            _workoutCategories(),
            const SizedBox(height: 24),
            _motivationCard(),
          ],
        ),
      ),
    );
  }

  Widget _todayWorkoutPlan(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [Colors.blue.shade800, Colors.indigo.shade900]
                  : [Colors.blue.shade300, Colors.indigo.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.accessibility_new, size: 40, color: Colors.white),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Full Body Workout",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "45 mins • Intense",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Start"),
          ),
        ],
      ),
    );
  }

  Widget _weeklyProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weekly Progress",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _progressRow("Workouts", 0.6, Colors.green),
        const SizedBox(height: 10),
        _progressRow("Calories Burned", 0.45, Colors.orange),
        const SizedBox(height: 10),
        _progressRow("Steps", 0.75, Colors.blue),
      ],
    );
  }

  Widget _progressRow(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        LinearPercentIndicator(
          animation: true,
          lineHeight: 10,
          percent: percent,
          progressColor: color,
          backgroundColor: Colors.grey.shade300,
          barRadius: const Radius.circular(8),
        ),
      ],
    );
  }

  Widget _workoutCategories() {
    final categories = [
      {"icon": Icons.directions_run, "label": "Cardio"},
      {"icon": Icons.fitness_center, "label": "Strength"},
      {"icon": Icons.self_improvement, "label": "Yoga"},
      {"icon": Icons.directions_bike, "label": "Cycling"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Explore Workouts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData, color: Colors.blue, size: 30),
                  const SizedBox(width: 8),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _motivationCard() {
    return Card(
      color: Colors.orange.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.orange, size: 30),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '"Push yourself, because no one else is going to do it for you."',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
