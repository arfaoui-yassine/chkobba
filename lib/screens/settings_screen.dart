import 'package:flutter/material.dart';
import 'game_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController numberOfValuesController = TextEditingController(
    text: '6',
  );
  final TextEditingController lengthOfNumbersController = TextEditingController(
    text: '2',
  );

  int selectedDifficulty = 1;
  Color selectedDifficultyColor = Colors.green;
  List<Color> difficultyColors = [Colors.green, Colors.yellow, Colors.red];

  List<List<Color>> themes = [
    [Colors.grey.shade800, Colors.white],
    [Colors.white, Colors.black],
    [Colors.blue.shade100, Colors.red],
  ];
  List<Color> selectedTheme = [Colors.grey.shade800, Colors.white];

  void startGame() {
    final int n = int.tryParse(numberOfValuesController.text) ?? 5;
    final int x = int.tryParse(lengthOfNumbersController.text) ?? 3;

    final List<String> numbers = List.generate(n, (_) {
      return List.generate(
        x,
        (_) => (0 + (9 * (UniqueKey().hashCode % 10) / 10).floor()).toString(),
      ).join();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => GameScreen(
              numbers: numbers,
              themeColors: selectedTheme,
              difficulty: selectedDifficulty,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Game Settings',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildLabeledField("Number of Values", numberOfValuesController),
              const SizedBox(height: 24),
              _buildLabeledField(
                "Length of Numbers",
                lengthOfNumbersController,
              ),
              const SizedBox(height: 24),
              _buildColorSelector(
                "Difficulty",
                selectedDifficultyColor,
                difficultyColors,
                (color, index) {
                  setState(() {
                    selectedDifficultyColor = color;
                    selectedDifficulty = index + 1;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildColorSelector(
                "Theme",
                selectedTheme[0],
                themes.map((t) => t[0]).toList(),
                (color, index) {
                  setState(() {
                    selectedTheme = themes[index];
                  });
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: const Text(
                    'Start Memorization',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildLabeledField(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector(
    String label,
    Color selected,
    List<Color> options,
    Function(Color, int) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(options.length, (index) {
            final color = options[index];
            return GestureDetector(
              onTap: () => onSelect(color, index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
