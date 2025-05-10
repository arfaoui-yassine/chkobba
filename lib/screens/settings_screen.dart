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
  Color selectedDifficultyColor = const Color.fromARGB(255, 0, 228, 0);
  List<Color> difficultyColors = [
    const Color.fromARGB(255, 0, 228, 0),
    const Color.fromARGB(255, 231, 239, 0),
    const Color.fromARGB(255, 255, 93, 93),
  ];

  List<List<Color>> themes = [
    [Color.fromARGB(255, 173, 227, 246), Color.fromARGB(255, 13, 5, 255)],
    [Color.fromARGB(255, 253, 187, 251), Color.fromARGB(255, 137, 22, 130)],
    [Color.fromARGB(255, 51, 51, 51), Color.fromARGB(255, 255, 255, 255)],
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
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double fontScale = screenWidth / 430;
    final double verticalGap = 36 * fontScale;
    final double titleGap = 65 * fontScale;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 227, 246),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.only(bottom: 100 * fontScale),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 29 * fontScale,
                      vertical: 24 * fontScale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40 * fontScale,
                            bottom: titleGap,
                          ),
                          child: Center(
                            child: Text(
                              'Game Settings',
                              style: TextStyle(
                                fontFamily: 'Risque',
                                fontSize: 40 * fontScale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        _buildLabeledField(
                          "Number of Values",
                          numberOfValuesController,
                          fontScale,
                        ),
                        SizedBox(height: verticalGap),
                        _buildLabeledField(
                          "Length of Numbers",
                          lengthOfNumbersController,
                          fontScale,
                        ),
                        SizedBox(height: verticalGap),
                        _buildLabeledColor(
                          "Difficulty",
                          selectedDifficultyColor,
                          fontScale,
                        ),
                        SizedBox(height: 24 * fontScale),
                        _buildColorOptions(difficultyColors, (color, index) {
                          setState(() {
                            selectedDifficultyColor = color;
                            selectedDifficulty = index + 1;
                          });
                        }, fontScale),
                        SizedBox(height: verticalGap),
                        _buildLabeledColor(
                          "Theme",
                          selectedTheme[0],
                          fontScale,
                        ),
                        SizedBox(height: 24 * fontScale),
                        _buildColorOptions(themes.map((t) => t[0]).toList(), (
                          color,
                          index,
                        ) {
                          setState(() {
                            selectedTheme = themes[index];
                          });
                        }, fontScale),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: startGame,
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
                    'Start Memorization',
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

  Widget _buildLabeledField(
    String label,
    TextEditingController controller,
    double fontScale,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25 * fontScale,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 80 * fontScale,
          height: 50 * fontScale,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16 * fontScale),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 3.5),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 3.5),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledColor(String label, Color selected, double fontScale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25 * fontScale,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 80 * fontScale,
          height: 50 * fontScale,
          decoration: BoxDecoration(
            color: selected,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black, width: 3.5),
          ),
        ),
      ],
    );
  }

  Widget _buildColorOptions(
    List<Color> options,
    Function(Color, int) onSelect,
    double fontScale,
  ) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 80 * fontScale,
      runSpacing: 40 * fontScale,
      children: List.generate(options.length, (index) {
        final color = options[index];
        return GestureDetector(
          onTap: () => onSelect(color, index),
          child: Container(
            width: 70 * fontScale,
            height: 60 * fontScale,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.black, width: 3.5),
            ),
          ),
        );
      }),
    );
  }
}
