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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FB);
    final cardGradient =
        isDark
            ? [Colors.grey.withOpacity(0.3), Colors.black.withOpacity(0.1)]
            : [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.2)];
    final shadowColor = isDark ? Colors.black26 : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final progressBackground = isDark ? Colors.grey[800] : Colors.grey[300];

    final filteredTeam =
        teammates
            .where(
              (member) => member['name'].toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Team",
          style: TextStyle(
            color: textColor,
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
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                hintText: 'Search teammates...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
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
                      colors: cardGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
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
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member['status'],
                              style: TextStyle(color: subtitleColor),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: member['progress'],
                              backgroundColor: progressBackground,
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
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: isDark ? Colors.white54 : Colors.black45,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? Colors.white : const Color.fromARGB(255, 36, 36, 36);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: "invite",
          onPressed: _shareLinkToWhatsApp,
          icon: const Icon(Icons.person_add),
          label: Text("Invite", style: TextStyle(color: labelColor)),
          backgroundColor: const Color.fromARGB(255, 144, 103, 255),
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "group",
          onPressed: () {
            // Create Group logic
          },
          icon: const Icon(Icons.group),
          label: Text("Create Group", style: TextStyle(color: labelColor)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: isDark ? Colors.black : null,
      ),
      body: Center(
        child: Text(
          "$name's fitness profile coming soon!",
          style: TextStyle(
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
