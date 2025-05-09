import 'package:flutter/material.dart';
import 'package:chkobba/screens/game_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? selectedDifficulty = 1; // Default to medium difficulty
  int? selectedTheme = 0; // Default to classic theme
  final TextEditingController numberValuesController = TextEditingController(text: '5');
  final TextEditingController numberLengthController = TextEditingController(text: '2');

  @override
  void dispose() {
    numberValuesController.dispose();
    numberLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFADE3F6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        const Text(
                          'Game Settings',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Risque',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Number of Values
                        _buildLabeledInput('Number of Values', numberValuesController),
                        const SizedBox(height: 16),

                        // Length of Numbers
                        _buildLabeledInput('Length of Numbers', numberLengthController),
                        const SizedBox(height: 16),

                        // Difficulty Section
                        _buildSectionTitle('Difficulty'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _difficultyOption(0, Colors.green, 'Easy'),
                            _difficultyOption(1, Colors.orange, 'Medium'),
                            _difficultyOption(2, Colors.red, 'Hard'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Theme Section
                        _buildSectionTitle('Theme'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _themeOption(0, 'Classic'),
                            _themeOption(1, 'Dark'),
                            _themeOption(2, 'Ocean'),
                          ],
                        ),
                        const Spacer(),

                        // Start Button
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          child: OutlinedButton(
                            onPressed: _startGame,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              side: const BorderSide(color: Colors.black, width: 2),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text(
                              'Start Game',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLabeledInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _difficultyOption(int index, Color color, String label) {
    final isSelected = selectedDifficulty == index;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => selectedDifficulty = index),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 30)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _themeOption(int index, String themeName) {
    final isSelected = selectedTheme == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTheme = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: Colors.black,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          themeName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _startGame() {
    final valuesText = numberValuesController.text;
    final lengthText = numberLengthController.text;

    if (valuesText.isEmpty || lengthText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }

    final numberCount = int.tryParse(valuesText);
    final numberLength = int.tryParse(lengthText);

    if (numberCount == null || numberLength == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    if (numberCount < 1 || numberLength < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numbers must be greater than 0')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          numberCount: numberCount,
          numberLength: numberLength,
          themeIndex: selectedTheme ?? 0,
          difficultyIndex: selectedDifficulty ?? 1,
        ),
      ),
    );
  }
}