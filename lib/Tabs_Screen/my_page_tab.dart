// ignore_for_file: use_build_context_synchronously, deprecated_member_use, library_private_types_in_public_api, unused_field

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_fitness_pro/Authentication/login_screen.dart';
import 'package:my_fitness_pro/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPageTab extends StatefulWidget {
  const MyPageTab({super.key});

  @override
  _MyPageTabState createState() => _MyPageTabState();
}

class _MyPageTabState extends State<MyPageTab> {
  final user = FirebaseAuth.instance.currentUser;
  File? _profileImage;
  String _appVersion = '1.000 (1)';
  final String _appName = 'My Fitness Pro';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${info.version} (${info.buildNumber})";
    });
  }

  void _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            title: const Text("Confirm Logout"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Logout"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> pickImage() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please grant photo permission")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "My Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage != null
                        ? FileImage(_profileImage!)
                        : NetworkImage(
                              user?.photoURL ??
                                  'https://www.facebook.com/photo?fbid=997450045650315&set=a.101566011905394',
                            )
                            as ImageProvider,
                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                child:
                    _profileImage == null
                        ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: isDark ? Colors.white70 : Colors.white,
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'User Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              user?.email ?? 'Email',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
            ),

            const SizedBox(height: 30),
            Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),

            // --- Fitness Overview ---
            const ListTile(
              leading: Icon(Icons.local_fire_department),
              title: Text("Calories Burned This Week"),
              trailing: Text("1,240 kcal"),
            ),
            const ListTile(
              leading: Icon(Icons.directions_walk),
              title: Text("Steps Today"),
              trailing: Text("6,528"),
            ),
            const ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text("Workout Streak"),
              trailing: Text("4 Days"),
            ),

            // --- Goals ---
            Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Goals"),
              subtitle: const Text("Daily: 8,000 steps, 2,000 kcal"),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),

            // --- Mood Tracker ---
            ListTile(
              leading: const Icon(Icons.mood),
              title: const Text("Today's Mood"),
              subtitle: const Text("😊 Feeling Good"),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),

            // --- Achievements ---
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text("Achievements"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            // --- Dark Mode Toggle ---
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: isDark,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            ),

            // --- Settings ---
            Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
            ListTile(
              leading: Icon(Icons.settings, color: textColor),
              title: Text(
                "Account Settings",
                style: TextStyle(color: textColor),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: textColor,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.support_agent, color: textColor),
              title: Text("Help & Support", style: TextStyle(color: textColor)),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: textColor,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),

            // --- App Version ---
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                "App Version: $_appVersion",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
