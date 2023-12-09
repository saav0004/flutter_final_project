import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/share_code_screen");
              },
              child: const Text('Start session'),
            ),
            const Text("Welcome to the app"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/enter_code_screen");
              },
              child: const Text('Enter code'),
            ),
          ],
        ),
      ),
    );
  }
}
