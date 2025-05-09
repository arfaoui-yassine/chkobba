import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correctCount;
  final int totalCount;
  final int themeIndex;

  const ResultScreen({
    super.key,
    required this.correctCount,
    required this.totalCount,
    required this.themeIndex,
  });

  Color _getBackgroundColor() {
    switch (themeIndex) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.black;
      case 2:
        return const Color(0xFFADE3F6);
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor() {
    return themeIndex == 1 ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (correctCount / totalCount * 100).round();
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Results',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(
                    percentage >= 80
                        ? 'assets/fluffy_happy.png'
                        : percentage >= 50
                            ? 'assets/fluffy_normal.png'
                            : 'assets/fluffy_sad.png',
                    height: 150,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'You remembered $correctCount out of $totalCount numbers',
                      style: TextStyle(
                        fontSize: 24,
                        color: _getTextColor(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '($percentage% correct)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Responsive button row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 400) {
                        // Wide screen - horizontal buttons
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildButtons(context),
                        );
                      } else {
                        // Narrow screen - vertical buttons
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _buildButtons(context)
                              .map((button) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: button,
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Updated _buildButtons method to accept BuildContext
  List<Widget> _buildButtons(BuildContext context) {
    return [
      SizedBox(
        width: 200, // Fixed width for consistency
        child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Main Menu',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      const SizedBox(width: 16),
      SizedBox(
        width: 200, // Fixed width for consistency
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Try Again',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    ];
  }
}