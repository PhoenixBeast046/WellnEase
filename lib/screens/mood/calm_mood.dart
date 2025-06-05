// lib/screens/mood/calm_mood.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/api_service.dart';
import '../../services/data_service.dart';

class CalmMoodPage extends StatefulWidget {
  static const routeName = '/mood/calm';
  const CalmMoodPage({Key? key}) : super(key: key);

  @override
  State<CalmMoodPage> createState() => _CalmMoodPageState();
}

class _CalmMoodPageState extends State<CalmMoodPage> {
  late Future<Map<String, dynamic>> quoteFuture;
  bool _moodRecorded = false;

  // Soft green gradient
  static const Color lightColor = Color(0xFFE8F5E9);
  static const Color darkColor = Color(0xFFA5D6A7);

  @override
  void initState() {
    super.initState();
    quoteFuture = ApiService.fetchQuote();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_moodRecorded) {
      _moodRecorded = true;
      context.read<DataService>().setLastMood('calm');
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarPath = context.watch<DataService>().avatarPath;
    final avatarImage = avatarPath != null
        ? FileImage(File(avatarPath)) as ImageProvider
        : const AssetImage('assets/placeholder_logo.png');
    final appIcon = const AssetImage('assets/placeholder_logo.png');
    final samples = context.watch<DataService>().getRecentSamples(4);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [lightColor, darkColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                        IconButton(
                          icon: Image(image: appIcon, width: 32, height: 32),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/dashboard'),
                        ),
                        const Spacer(),
                        const Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: CircleAvatar(
                            radius: 16,
                            backgroundImage: avatarImage,
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/profile'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // GIF & Message
                Image.asset('assets/mood_calm.gif',
                    width: 145, height: 145),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Savor the peace! 🧘‍♀️\nA short meditation or gentle music could help maintain this feeling.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 16),

                // Chart
                if (samples.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: samples
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                    e.key.toDouble(),
                                    e.value.heartRate.toDouble()))
                                .toList(),
                            isCurved: true,
                            color: Colors.green.shade800,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: samples
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                    e.key.toDouble(),
                                    e.value.sleepScore.toDouble()))
                                .toList(),
                            isCurved: true,
                            color: Colors.yellowAccent,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No health data yet.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),

                const SizedBox(height: 16),

                // Quote
                FutureBuilder<Map<String, dynamic>>(
                  future: quoteFuture,
                  builder: (ctx, snap) {
                    if (snap.hasData) {
                      final q = snap.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Text(
                              '"${q["q"]}"',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '- ${q["a"]}',
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snap.hasError)
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Failed to load quote.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Chat Button
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                      context, '/assistant',
                      arguments: 'calm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: darkColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                    child: const Text(
                    'Chat with Assistant',
                    style: TextStyle(color: Colors.black),
                    ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
