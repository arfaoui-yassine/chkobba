import 'dart:async';
import 'package:flutter/material.dart';
import 'input_screen.dart';

class GameScreen extends StatefulWidget {
  final List<String> numbers;
  final List<Color> themeColors;
  final int difficulty;

  const GameScreen({
    super.key,
    required this.numbers,
    required this.themeColors,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentIndex = 0;
  bool showNumber = false;
  Timer? _timer;

  Duration get flashDuration {
    switch (widget.difficulty) {
      case 1:
        return const Duration(seconds: 2);
      case 2:
        return const Duration(seconds: 1);
      case 3:
      default:
        return const Duration(milliseconds: 500);
    }
  }

  @override
  void initState() {
    super.initState();

    print("📋 Received numbers: ${widget.numbers}");
    print("🎨 Received theme colors: ${widget.themeColors}");
    print("⚙️ Difficulty: ${widget.difficulty}");

    startFlashing();
  }

  void startFlashing() {
    _timer = Timer.periodic(flashDuration, (timer) {
      setState(() {
        showNumber = !showNumber;
        if (!showNumber) currentIndex++;
      });

      if (currentIndex >= widget.numbers.length) {
        _timer?.cancel();

        // Navigate to InputScreen after a short delay to let last number disappear
        Future.delayed(flashDuration, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => InputScreen(
                    numbersToGuess: widget.numbers,
                    themeColors: widget.themeColors,
                  ),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeColors[0],
      body: Center(
        child: Text(
          (currentIndex < widget.numbers.length && showNumber)
              ? widget.numbers[currentIndex]
              : '',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: widget.themeColors[1],
          ),
        ),
      ),
    );
  }
}
