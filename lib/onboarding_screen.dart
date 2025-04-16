// ignore_for_file: use_build_context_synchronously

import 'package:my_fitness_pro/Authentication/signupOptionsScreen.dart'
    as signup;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import the smooth page indicator package
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0; // Track the current page index

  // Function to move to the next page
  void nextPage() {
    if (_controller.page! < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // After the last page, set onboarding as complete and navigate to SignUpScreen
      completeOnboarding();
    }
  }

  // Skip the onboarding and go directly to the SignUpScreen
  void skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true); // Set onboarding as completed

    // Navigate to SignUpScreen instead of LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const signup.SignupOptionsScreen(),
      ), // Navigate to SignUpScreen
    );
  }

  // Method to complete the onboarding process and navigate to SignUpScreen
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true); // Set onboarding as completed

    // Navigate to SignUpScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const signup.SignupOptionsScreen(),
      ), // Navigate to SignUpScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding pages
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              OnboardingPage(
                title: "Welcome to Fitness App",
                description: "Track your fitness journey with ease.",
                imagePath:
                    "assets/onboarding1.webp", // Ensure you have the image in assets
                onSkip: skipOnboarding, // Add skip functionality
              ),
              OnboardingPage(
                title: "Get Personalized Plans",
                description: "Customized fitness plans just for you.",
                imagePath:
                    "assets/onboarding2.webp", // Ensure you have the image in assets
                onSkip: skipOnboarding, // Add skip functionality
              ),
              OnboardingPage(
                title: "Track Your Progress",
                description: "See your growth over time.",
                imagePath:
                    "assets/onboarding3.webp", // Ensure you have the image in assets
                onSkip: skipOnboarding, // Add skip functionality
              ),
              // Last page with "Get Started" button
              LastOnboardingPage(
                onStart: completeOnboarding,
                onSkip: skipOnboarding,
              ),
            ],
          ),

          // Page indicator (dots) at the bottom
          Positioned(
            top: 600,
            left: 0,
            right: 0,
            child: Center(
              child:
                  currentPage < 3
                      ? SmoothPageIndicator(
                        controller: _controller,
                        count: 4, // Total number of pages
                        effect: const ExpandingDotsEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                          activeDotColor: Colors.blue,
                        ),
                      )
                      : const SizedBox.shrink(), // Hide dots on the last page
            ),
          ),
          // Skip button on the top right corner
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: skipOnboarding, // Navigate to SignUpScreen
              child: const Text(
                "Skip",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onSkip;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class LastOnboardingPage extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onSkip;

  const LastOnboardingPage({
    super.key,
    required this.onStart,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/onboarding_final.png",
            height: 250,
          ), // You can set a final image for this page
          const SizedBox(height: 30),
          const Text(
            "You're All Set!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Now, let's get started with your fitness journey.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onStart, // This will complete the onboarding
            child: const Text("Get Started"),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed:
                onSkip, // Skip the onboarding process and go to SignUpScreen
            child: const Text(
              "Skip",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
