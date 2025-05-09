import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class InputScreen extends StatefulWidget {
  final List<String> numbersToGuess;
  final List<Color> themeColors;

  const InputScreen({
    super.key,
    required this.numbersToGuess,
    required this.themeColors,
  });

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final Set<String> _correctGuesses = {};
  int _correctCount = 0;
  int _faultCount = 0;
  Color _inputBgColor = Colors.white;
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 8)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_animationController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  void _submit() {
    final input = _controller.text.trim();
    _controller.clear();

    if (input.isEmpty || _correctGuesses.contains(input)) return;

    if (widget.numbersToGuess.contains(input)) {
      setState(() {
        _correctGuesses.add(input);
        _correctCount++;
        _inputBgColor = Colors.green.shade300;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _inputBgColor = Colors.white;
        });
      });
    } else {
      setState(() {
        _faultCount++;
        print("❌ Fault count: $_faultCount");
        _inputBgColor = Colors.red.shade300;
      });
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _inputBgColor = Colors.white;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeColors[0],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Input',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$_correctCount / ${widget.numbersToGuess.length}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final offset = _shakeAnimation.value;
                return Transform.translate(
                  offset: Offset(Random().nextBool() ? offset : -offset, 0),
                  child: child,
                );
              },
              child: Container(
                width: 150,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: _inputBgColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.themeColors[1],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.black),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
