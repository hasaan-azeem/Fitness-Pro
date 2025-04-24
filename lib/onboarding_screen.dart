// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_fitness_pro/Authentication/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildPage(
        image: 'assets/onboarding1.jpg',
        title: "Welcome to Fitness Pro",
        subtitle: "Your journey starts here. Track, train and transform.",
      ),
      buildPage(
        image: 'assets/onboarding2.jpg',
        title: "Personalized Plans",
        subtitle: "Smart workouts tailored to your fitness level.",
      ),
      buildPage(
        image: 'assets/onboarding3.jpg',
        title: "Track Progress",
        subtitle: "Visualize your growth and stay motivated daily.",
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => isLastPage = index == pages.length - 1);
            },
            itemBuilder: (_, index) => pages[index],
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: SmoothPageIndicator(
              controller: _controller,
              count: pages.length,
              // ignore: prefer_const_constructors
              effect: WormEffect(
                activeDotColor: Colors.blue,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: completeOnboarding,
              child: const Text("Skip", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          if (isLastPage) {
            completeOnboarding();
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Icon(isLastPage ? Icons.check : Icons.arrow_forward),
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.72),
            BlendMode.darken,
          ),
        ),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
