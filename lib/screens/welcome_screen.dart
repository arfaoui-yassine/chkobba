import 'package:chkobba/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = screenWidth / 430;

    return Scaffold(
      backgroundColor: const Color(0xFFADE3F6),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Fluffu Corps Icon
                  Image.asset('assets/fluffu_logo.png', height: 260),

                  const SizedBox(height: 20),

                  // Game Title with custom typography
                  Stack(
                    children: [
                      // Text shadow effect
                      Text(
                        'Chkobba',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Risque',
                          color: Colors.black.withOpacity(0.2),
                          letterSpacing: 0,
                          height: 1.0,
                        ),
                      ),
                      // Main text
                      Text(
                        'Chkobba',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Risque',
                          color: Colors.black,
                          letterSpacing: 0,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Start Game Button - Fixed 20px from Bottom
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 62 * fontScale,
                      vertical: 25 * fontScale,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Colors.black, width: 4),
                    ),
                  ),
                  child: Text(
                    'Start Game',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25 * fontScale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
