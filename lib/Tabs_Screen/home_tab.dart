import 'package:flutter/material.dart';
import 'package:my_fitness_pro/widgets/circular_progress.dart';
import 'package:my_fitness_pro/widgets/greeting_section.dart';
import 'package:my_fitness_pro/widgets/stat_card.dart';
import 'package:my_fitness_pro/widgets/tip_banner.dart';
import 'package:my_fitness_pro/widgets/weekly_calendar.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingSection(),
            SizedBox(height: 20),
            Center(child: CircularProgressSection()),
            SizedBox(height: 30),
            TipBanner(),
            SizedBox(height: 20),
            StatCardsRow(),  // includes steps, calories, distance, etc.
            SizedBox(height: 30),
            WeeklyCalendar(),
          ],
        ),
      ),
    );
  }
}
