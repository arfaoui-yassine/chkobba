import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'input_screen.dart';

class GamePage extends StatefulWidget {
  final int numberCount;
  final int numberLength;
  final int themeIndex;
  final int difficultyIndex;

  const GamePage({
    super.key,
    required this.numberCount,
    required this.numberLength,
    required this.themeIndex,
    required this.difficultyIndex,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}


class _GamePageState extends State<GamePage> {
  late List<String> numbers;
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    numbers = generateNumbers(widget.numberCount, widget.numberLength);
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

 // In game_screen.dart, update the timer callback in startTimer()
void startTimer() {
  int delaySeconds;

  switch (widget.difficultyIndex) {
    case 0: delaySeconds = 3; break;
    case 1: delaySeconds = 2; break;
    case 2: delaySeconds = 1; break;
    default: delaySeconds = 2;
  }

  timer = Timer.periodic(Duration(seconds: delaySeconds), (Timer t) {
    if (currentIndex < numbers.length - 1) {
      setState(() => currentIndex++);
    } else {
      t.cancel();
      // Navigate to InputScreen after showing all numbers
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InputScreen(
              correctNumbers: numbers,
              themeIndex: widget.themeIndex,
              difficultyIndex: widget.difficultyIndex,
            ),
          ),
        );
      });
    }
  });
}


  List<String> generateNumbers(int count, int length) {
    final rand = Random();
    return List.generate(count, (_) {
      return List.generate(length, (_) => rand.nextInt(10).toString()).join();
    });
  }

  Color _getBackgroundColor(int themeIndex) {
    switch (themeIndex) {
      case 0: return Colors.white;
      case 1: return Colors.black;
      case 2: return const Color(0xFFADE3F6); // Ocean theme
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(widget.themeIndex),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Counter
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                '${currentIndex + 1} / ${numbers.length}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.themeIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),

            // Number
            Center(
              child: Text(
                numbers[currentIndex],
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: widget.themeIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),

            // Fluffy image
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Image.asset(
                '../../assets/fluffy1.png', // Assure-toi que cette image est bien dans ton dossier assets
                height: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
