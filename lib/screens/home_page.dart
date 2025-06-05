import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/data_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<FlSpot> getPaddedSpots(List<double> values, {double defaultValue = 0}) {
  final paddedValues = List<double>.from(values);
  while (paddedValues.length < 5) {
    paddedValues.insert(0, defaultValue); // Use 0 or average value
  }

  return paddedValues
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), e.value))
      .toList();
}


  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final hrSamples = data.getLastSamples(5);
    final moodList = data.getRecentMoods(5);

    // map mood→numeric for charting
    const moodMap = {
      'happy': 5.0,
      'calm': 4.0,
      'neutral': 3.0,
      'sad': 2.0,
      'angry': 1.0,
      'stressed': 1.0,
    };
    final moodValues = moodList.map((m) => moodMap[m] ?? 3.0).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WellnEase'),
        centerTitle: true,
        backgroundColor: const Color(0xFF7B9E9B),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/placeholder_logo.png'),
            ),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/mood/happy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: const Text(
              'Track Emotion',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/health/summary'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: const Text(
              'Track Health',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          const SizedBox(height: 24),

          // show current mood if any
          if (data.lastMood != null) ...[
            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: Text(
                  'Current Mood: ${data.lastMood![0].toUpperCase()}${data.lastMood!.substring(1)}',
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // HEART RATE chart
if (hrSamples.isNotEmpty) ...[
  const Text(
    'Recent Heart Rate',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  SizedBox(
    height: 150,
    child: LineChart(
      LineChartData(
        minY: 50,
        maxY: 150,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: getPaddedSpots(
              hrSamples.map((e) => e.heartRate.toDouble()).toList(),
              defaultValue: 70,
            ),
            isCurved: true,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) => true,
            ),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.4),
                  Colors.red.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
  const SizedBox(height: 24),

            // SLEEP HOURS chart
const Text(
  'Recent Sleep Hours',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
SizedBox(
  height: 150,
  child: LineChart(
    LineChartData(
      minY: 0,
      maxY: 12,
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: getPaddedSpots(
            hrSamples.map((e) => e.sleepScore.toDouble()).toList(),
            defaultValue: 7,
          ),
          isCurved: true,
          dotData: FlDotData(
            show: true,
          ),
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.4),
                Colors.blue.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ),
  ),
),
const SizedBox(height: 24),

            // MOOD chart
            const Text(
              'Recent Mood (1=Angry→5=Happy)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  minY: 1,
                  maxY: 5,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= moodList.length) {
                            return const SizedBox();
                          }
                          return Text(
                            moodList[idx][0].toUpperCase(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 24,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: getPaddedSpots(
  moodValues,
  defaultValue: 3, // Neutral mood
),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.4),
                            Colors.purple.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
