// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io'; // For exit(0)
import '../Tabs_Screen/fitness_tab.dart';
import '../Tabs_Screen/team_tab.dart';
import '../Tabs_Screen/home_tab.dart';
import '../Tabs_Screen/my_page_tab.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Welcome to the Home Dashboard!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const FitnessTab(),
    const TeamTab(),
    const MyPageTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Exit the app when the back button is pressed
        exit(0);
      },
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Fitness',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Team'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Page'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
