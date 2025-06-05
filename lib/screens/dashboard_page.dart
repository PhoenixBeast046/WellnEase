import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/data_service.dart';
import 'assistant/chat_page.dart';
import 'mood/happy_mood.dart';
import 'mood/sad_mood.dart';
import 'mood/angry_mood.dart';
import 'mood/calm_mood.dart';
import 'mood/stressed_mood.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _heartRate = 75;
  String _selectedMood = 'happy';
  int _sleepHours = 8;

  // Theme colors
  static const Color topColor = Color(0xFF7B9E9B);
  static const Color bottomColor = Color(0xFF493C6B);

  void _decrementSleep() {
    if (_sleepHours > 0) setState(() => _sleepHours--);
  }

  void _incrementSleep() {
    if (_sleepHours < 24) setState(() => _sleepHours++);
  }

  @override
  Widget build(BuildContext context) {
    final avatarPath = context.watch<DataService>().avatarPath;
    final avatarImage = avatarPath != null
        ? FileImage(File(avatarPath))
        : const AssetImage('assets/placeholder_logo.png') as ImageProvider;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [topColor, bottomColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ─── Custom Top Bar ────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/placeholder_logo.png',
                        width: 32,
                        height: 32,
                      ),
                      const Spacer(),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfilePage()),
                        ),
                        child: CircleAvatar(
                          backgroundImage: avatarImage,
                          radius: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Body Cards ─────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Heart Rate card
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.favorite, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    'Heart Rate',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _heartRate,
                                min: 40,
                                max: 140,
                                divisions: 20,
                                label: '${_heartRate.round()} bpm',
                                onChanged: (v) =>
                                    setState(() => _heartRate = v),
                              ),
                              Text(
                                '${_heartRate.round()} bpm is set',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Mood picker card with emojis
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Select Your Mood',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: _selectedMood,
                                isExpanded: true,
                                onChanged: (val) =>
                                    setState(() => _selectedMood = val!),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'happy',
                                    child: Text('😊 Happy'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'sad',
                                    child: Text('😢 Sad'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'angry',
                                    child: Text('😠 Angry'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'calm',
                                    child: Text('😌 Calm'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'stressed',
                                    child: Text('😟 Stressed'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sleep Hours + navigation card (stepper)
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.bed, color: Colors.indigo),
                              const SizedBox(width: 8),
                              const Text(
                                'Sleep Hours',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 1),
                              IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline),
                                color: Colors.indigo,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 24, minHeight: 24),
                                onPressed: _decrementSleep,
                              ),
                              Text(
                                ' $_sleepHours h ',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline),
                                color: Colors.indigo,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 24, minHeight: 24),
                                onPressed: _incrementSleep,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/health/sleep-quality'),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Continue button: record sample + mood, then navigate
              ElevatedButton(
                onPressed: () {
                  final svc = context.read<DataService>();
                  svc.addSample(
                    heartRate: _heartRate.round(),
                    sleepScore: _sleepHours,
                  );
                  svc.addMood(_selectedMood);

                  switch (_selectedMood) {
                    case 'happy':
                      Navigator.pushNamed(
                          context, HappyMoodPage.routeName);
                      break;
                    case 'sad':
                      Navigator.pushNamed(context, SadMoodPage.routeName);
                      break;
                    case 'angry':
                      Navigator.pushNamed(
                          context, AngryMoodPage.routeName);
                      break;
                    case 'calm':
                      Navigator.pushNamed(context, CalmMoodPage.routeName);
                      break;
                    case 'stressed':
                      Navigator.pushNamed(
                          context, StressedMoodPage.routeName);
                      break;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: bottomColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Continue'),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, ChatPage.routeName),
        backgroundColor: Colors.white,
        child: const Icon(Icons.chat, color: topColor),
      ),
    );
  }
}
