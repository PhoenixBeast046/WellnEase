//lib\screens\welcome_page.dart
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFF7B9E9B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Stack(
            children: [
              // Background ovals...
              const Positioned(
                left: -98,
                top: -74,
                child: SizedBox(
                  width: 359,
                  height: 359,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x38FBC6E6),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: -76,
                top: 494,
                child: SizedBox(
                  width: 488,
                  height: 437,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x07FBC6E6),
                    ),
                  ),
                ),
              ),

              // Your animated logo/GIF
              Positioned(
                left: 40,
                top: 252,
                child: SizedBox(
                  width: 310,
                  height: 213,
                  child: Image.asset(
                    'assets/placeholder_logo.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              // Title & subtitle
              const Positioned(
                left: 62,
                top: 465,
                child: SizedBox(
                  width: 275,
                  height: 57,
                  child: Center(
                    child: Text(
                      'Well‘n’Ease',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontFamily: 'Familjen Grotesk',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 177,
                top: 811,
                child: SizedBox(
                  width: 196,
                  height: 33,
                  child: Center(
                    child: Text(
                      'Track Your Wellness, Effortlessly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Familjen Grotesk',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // Get Started button
              Positioned(
                left: 100,
                bottom: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
