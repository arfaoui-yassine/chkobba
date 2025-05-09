import 'package:chkobba/screens/settings_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MemorizationGameApp());
}

class MemorizationGameApp extends StatelessWidget {
  const MemorizationGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorization Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
      home: const SettingsScreen(),
    );
  }
}
