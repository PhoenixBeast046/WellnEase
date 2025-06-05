//lib\screens\health\track_health_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/data_service.dart';

class TrackHealthPage extends StatelessWidget {
  const TrackHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final samples =
        context.watch<DataService>().getRecentSamples(4);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Summary'),
        backgroundColor: const Color(0xFF7B9E9B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, '/health/heart-rate'),
            child: const Text('Log Heart Rate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, '/health/sleep-quality'),
            child: const Text('Log Sleep Quality'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          if (samples.isNotEmpty)
            Expanded(
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
                          .map((e) => FlSpot(e.key.toDouble(),
                              e.value.heartRate.toDouble()))
                          .toList(),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.red,
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: samples
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(),
                              e.value.sleepScore.toDouble()))
                          .toList(),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            )
          else
            const Text('No data yet'),
        ]),
      ),
    );
  }
}
