//lib\main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/data_service.dart';
import 'screens/splash_page.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/mood/happy_mood.dart';
import 'screens/mood/sad_mood.dart';
import 'screens/mood/angry_mood.dart';
import 'screens/mood/calm_mood.dart';
import 'screens/mood/stressed_mood.dart';
import 'screens/assistant/chat_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DataService(),
      child: const WellnEaseApp(),
    ),
  );
}

class WellnEaseApp extends StatelessWidget {
  const WellnEaseApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WellnEase',
      theme: ThemeData.light(),
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (_) => const SplashPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        DashboardPage.routeName: (_) => const DashboardPage(),
        HappyMoodPage.routeName: (_) => const HappyMoodPage(),
        SadMoodPage.routeName: (_) => const SadMoodPage(),
        AngryMoodPage.routeName: (_) => const AngryMoodPage(),
        CalmMoodPage.routeName: (_) => const CalmMoodPage(),
        StressedMoodPage.routeName: (_) => const StressedMoodPage(),
        ChatPage.routeName: (_) => const ChatPage(),
      },
    );
  }
}
