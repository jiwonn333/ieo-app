import 'package:flutter/material.dart';

class MatchHomeScreen extends StatelessWidget {
  const MatchHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 인연'),
      ),
      body: const Center(
        child: Text('매칭 홈 화면'),
      ),
    );
  }
}