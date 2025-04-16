import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  String greeting = '';
  String userName = '';
  double progress = 0.65;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> tips = [
    "Stay hydrated throughout the day.",
    "A 10-minute walk can boost your mood.",
    "Stretching helps prevent injuries.",
    "Sleep at least 7-8 hours every night.",
    "Protein helps build and repair muscles.",
  ];

  @override
  void initState() {
    super.initState();
    getUserName();
    setGreeting();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  void getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? 'User';
    });
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

  String getTodayTip() {
    final day = DateTime.now().day;
    return tips[day % tips.length];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget circularStats(double size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.blueAccent,
                ),
              ),
            ),
            Text(
              "${(_animation.value * 100).toInt()}%",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$greeting, $userName 👋",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(child: circularStats(140)),
            const SizedBox(height: 30),

            // Workout Starter
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.fitness_center, color: Colors.white, size: 32),
                    Text(
                      "Start a Quick Workout",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Daily Activity Summary
            const Text(
              "Daily Activity",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard("Steps", "8,532"),
                _buildStatCard("Calories", "540 kcal"),
                _buildStatCard("Distance", "5.2 km"),
              ],
            ),
            const SizedBox(height: 30),

            // Tip of the Day
            const Text(
              "Tip of the Day",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(getTodayTip(), style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),

            // Weekly Calendar Placeholder
            const Text(
              "This Week",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildWeekCalendar(),

            const SizedBox(height: 30),
            const Text(
              "Mood Tracker",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                  size: 32,
                ),
                Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                  size: 32,
                ),
                Icon(Icons.sentiment_neutral, color: Colors.amber, size: 32),
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.orange,
                  size: 32,
                ),
                Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                  size: 32,
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              "Achievements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 32),
                SizedBox(width: 10),
                Text("5-Day Streak!", style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        DateTime day = today.subtract(
          Duration(days: currentWeekday - index - 1),
        );
        bool isToday = day.day == today.day;

        return Column(
          children: [
            Text(
              DateFormat.E().format(day),
              style: TextStyle(color: isToday ? Colors.blue : Colors.grey),
            ),
            const SizedBox(height: 4),
            CircleAvatar(
              radius: 14,
              backgroundColor: isToday ? Colors.blue : Colors.grey.shade300,
              child: Text(
                "${day.day}",
                style: TextStyle(color: isToday ? Colors.white : Colors.black),
              ),
            ),
          ],
        );
      }),
    );
  }
}
