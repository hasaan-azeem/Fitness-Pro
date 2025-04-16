// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamTab extends StatefulWidget {
  const TeamTab({super.key});

  @override
  State<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
  final List<Map<String, dynamic>> teammates = [
    {
      'name': 'Alice',
      'status': '💪 Crushing it!',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'online': true,
      'progress': 0.8,
    },
    {
      'name': 'Bob',
      'status': '😴 Rest Day',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'online': false,
      'progress': 0.3,
    },
    {
      'name': 'Charlie',
      'status': '✅ Workout Complete',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'online': true,
      'progress': 1.0,
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTeam =
        teammates
            .where(
              (member) => member['name'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Team",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search teammates...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTeam.length,
              itemBuilder: (context, index) {
                final member = filteredTeam[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(member['avatar']),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color:
                                      member['online']
                                          ? Colors.green
                                          : Colors.grey,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          member['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['status'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: member['progress'],
                              backgroundColor: Colors.grey[300],
                              color: Colors.greenAccent.shade400,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      TeammateDetailPage(name: member['name']),
                            ),
                          );
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const ExpandableFab(),
    );
  }
}

class ExpandableFab extends StatelessWidget {
  const ExpandableFab({super.key});

  // Function to share link to WhatsApp
  Future<void> _shareLinkToWhatsApp() async {
    const String whatsappUrl =
        'https://wa.me/?text=Check%20out%20this%20fitness%20app!';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: "invite",
          onPressed: _shareLinkToWhatsApp, // Share via WhatsApp
          icon: const Icon(Icons.person_add),
          label: const Text(
            "Invite",
            style: TextStyle(color: Color.fromARGB(255, 36, 36, 36)),
          ),
          backgroundColor: const Color.fromARGB(255, 144, 103, 255),
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "group",
          onPressed: () {
            // Create Group logic
          },
          icon: const Icon(Icons.group),
          label: const Text(
            "Create Group",
            style: TextStyle(color: Color.fromARGB(255, 36, 36, 36)),
          ),
          backgroundColor: Colors.lightBlue,
        ),
      ],
    );
  }
}

class TeammateDetailPage extends StatelessWidget {
  final String name;
  const TeammateDetailPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text(
          "$name's fitness profile coming soon!",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
