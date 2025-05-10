import 'package:chkobba/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ResultsScreen extends StatefulWidget {
  final List<String> numbersToGuess;
  final Set<String> guessedNumbers;
  final VoidCallback onRestart;
  final List<Color> themeColors;

  const ResultsScreen({
    super.key,
    required this.numbersToGuess,
    required this.guessedNumbers,
    required this.onRestart,
    required this.themeColors,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    if (widget.guessedNumbers.length == widget.numbersToGuess.length) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guessedCount = widget.guessedNumbers.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontScale = screenWidth / 430;
    final horizontalPadding = 32.0;
    final itemSpacing = 16.0;
    final itemsPerRow = 4;
    final availableWidth =
        screenWidth -
        (horizontalPadding * 2) -
        ((itemsPerRow - 1) * itemSpacing);
    final itemWidth = availableWidth / itemsPerRow;

    return Scaffold(
      backgroundColor: widget.themeColors[0],
      body: SafeArea(
        child: Stack(
          children: [
            // Full screen container to allow proper stacking
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 24 * fontScale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Result',
                            style: TextStyle(
                              fontFamily: 'Risque',
                              fontSize: 40 * fontScale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            '$guessedCount / ${widget.numbersToGuess.length}',
                            style: TextStyle(
                              fontSize: 25 * fontScale,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: itemSpacing,
                          runSpacing: itemSpacing,
                          alignment: WrapAlignment.center,
                          children:
                              widget.numbersToGuess.map((num) {
                                final isGuessed = widget.guessedNumbers
                                    .contains(num);
                                return Container(
                                  width: itemWidth,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        isGuessed
                                            ? Colors.green
                                            : const Color(0xFFFF7F7F),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  child: Text(
                                    num,
                                    style: TextStyle(
                                      fontSize: 20 * fontScale,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 🎉 Confetti
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive, // Spread in all directions
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [Colors.red, Colors.blue, Colors.green],
              // Adjust position to cover the whole screen
              blastDirection: 0, // In radians (0 means right, pi means left)
              minBlastForce: 5,
              maxBlastForce: 20,
            ),
            // 🔘 Restart Button (pinned 20px from bottom of screen)
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
                      horizontal: 130 * fontScale,
                      vertical: 25 * fontScale,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Colors.black, width: 4),
                    ),
                  ),
                  child: Text(
                    'Restart',
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
