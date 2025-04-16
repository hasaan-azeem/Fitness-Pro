import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FitnessTab extends StatelessWidget {
  const FitnessTab({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = DateTime.now();
    const greeting = "Your Fitness Journey";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              greeting,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Today’s Workout Plan
            _todayWorkoutPlan(),

            const SizedBox(height: 24),

            // Progress Summary
            _weeklyProgress(),

            const SizedBox(height: 24),

            // Workout Categories
            _workoutCategories(),

            const SizedBox(height: 24),

            // Motivational Tip
            _motivationCard(),
          ],
        ),
      ),
    );
  }

  Widget _todayWorkoutPlan() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Plan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.accessibility_new_rounded,
                  size: 40,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Full Body Workout"),
                    Text(
                      "45 mins • Intense",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Start"),
                ),
              ],
            ),
          ],
        ),
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
          backgroundColor: Colors.grey[300],
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
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData, color: Colors.deepPurple),
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
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
