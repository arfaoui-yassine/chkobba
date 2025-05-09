import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFADE3F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fluffu Corps Icon
            Image.asset(
              'assets/fluffu_logo.png',
              height: 150,
            ),

            const SizedBox(height: 20),

            // Game Title with custom typography
            Stack(
              children: [
                // Text shadow effect
                Text(
                  'Chkobba',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w400, // Regular weight
                    fontFamily: 'Risque', // Make sure to include this font in your pubspec.yaml
                    color: Colors.black.withOpacity(0.2),
                    letterSpacing: 0, // 0% letter spacing
                    height: 1.0, // Line height
                  ),
                ),
                // Main text
                Text(
                  'Chkobba',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w400, // Regular weight
                    fontFamily: 'Risque', // Make sure to include this font in your pubspec.yaml
                    color: Colors.black,
                    letterSpacing: 0, // 0% letter spacing
                    height: 1.0, // Line height
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Start Game Button with black border
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.black, // Black background
                foregroundColor: Colors.white, // White text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.black, // Black border
                    width: 2,
                  ),
                ),
                elevation: 4, // Shadow effect
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}