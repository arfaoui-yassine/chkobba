import 'package:flutter/material.dart';
import 'dart:async';
import 'result_screen.dart'; // Import the ResultScreen

class InputScreen extends StatefulWidget {
  final List<String> correctNumbers;
  final int themeIndex;
  final int difficultyIndex;

  const InputScreen({
    super.key,
    required this.correctNumbers,
    required this.themeIndex,
    required this.difficultyIndex,
  });

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  List<bool> correctAnswers = [];
  int currentInputIndex = 0;
  int wrongAttempts = 0;
  bool gameCompleted = false;
  bool gameLost = false;
  Timer? timer;
  List<String> userAnswers = [];
  List<String> remainingCorrectNumbers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.correctNumbers.length,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(
      widget.correctNumbers.length,
      (index) => FocusNode(),
    );
    correctAnswers = List.filled(widget.correctNumbers.length, false);
    userAnswers = List.filled(widget.correctNumbers.length, '');
    remainingCorrectNumbers = List.from(widget.correctNumbers);
    Future.delayed(Duration.zero, () => focusNodes[0].requestFocus());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    timer?.cancel();
    super.dispose();
  }

  void _checkAnswer(int index) {
    final userInput = controllers[index].text;
    
    setState(() {
      userAnswers[index] = userInput;
      
      // Check if the user input exists in remaining correct numbers
      if (remainingCorrectNumbers.contains(userInput)) {
        // Mark as correct
        correctAnswers[index] = true;
        // Remove this occurrence from remaining numbers
        remainingCorrectNumbers.remove(userInput);
        
        if (index < widget.correctNumbers.length - 1) {
          currentInputIndex = index + 1;
          focusNodes[currentInputIndex].requestFocus();
        } else {
          gameCompleted = true;
        }
      } else {
        wrongAttempts++;
        if (wrongAttempts >= 3) {
          gameLost = true;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          correctAnswers[index] ? 'Correct!' : 'Wrong! Try again.',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: correctAnswers[index] ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _submitAllAnswers() {
    int correctCount = correctAnswers.where((answer) => answer).length;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          correctCount: correctCount,
          totalCount: widget.correctNumbers.length,
          themeIndex: widget.themeIndex,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.themeIndex) {
      case 0: return Colors.white;
      case 1: return Colors.black;
      case 2: return const Color(0xFFADE3F6);
      default: return Colors.grey;
    }
  }

  Color _getTextColor() {
    return widget.themeIndex == 1 ? Colors.white : Colors.black;
  }

  Widget _buildFluffyImage() {
    if (gameLost) {
      return Image.asset('assets/fluffy_sad.png', height: 120);
    } else if (gameCompleted) {
      return Image.asset('assets/fluffy_happy.png', height: 120);
    } else {
      switch (wrongAttempts) {
        case 1: return Image.asset('assets/fluffy_confused1.png', height: 120);
        case 2: return Image.asset('assets/fluffy_confused2.png', height: 120);
        default: return Image.asset('assets/fluffy_normal.png', height: 120);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with progress
                  Text(
                    'Enter the numbers you remember:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${correctAnswers.where((answer) => answer).length}/${widget.correctNumbers.length} correct',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Wrong attempts indicator
                  if (wrongAttempts > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 3; i++)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i < wrongAttempts ? Colors.red : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Input fields
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.correctNumbers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: TextField(
                                  controller: controllers[index],
                                  focusNode: focusNodes[index],
                                  enabled: !correctAnswers[index] && !gameLost,
                                  decoration: InputDecoration(
                                    labelText: 'Number ${index + 1}',
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: correctAnswers[index]
                                        ? Colors.green.shade100
                                        : Colors.white,
                                    suffixIcon: correctAnswers[index]
                                        ? const Icon(Icons.check, color: Colors.green)
                                        : null,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (_) => _checkAnswer(index),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 1,
                                child: Image.asset(
                                  'assets/fluffy_icon.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Fluffy feedback image
                  _buildFluffyImage(),
                  const SizedBox(height: 16),

                  // Submit button
                  if (gameCompleted || gameLost)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: _submitAllAnswers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gameLost ? Colors.red : Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          gameLost ? 'Game Over - See Results' : 'Submit Answers',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}