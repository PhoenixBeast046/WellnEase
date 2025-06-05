//lib\screens\splash_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/';
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/splash.png', width: 400)),
    );
  }
}
