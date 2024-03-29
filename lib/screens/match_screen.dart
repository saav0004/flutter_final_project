import 'package:final_project/screens/welcome_screen.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/material.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key, required this.matchedMovie});
  final Movie matchedMovie;
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You matched with ${widget.matchedMovie.title}!',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.network(
              'https://image.tmdb.org/t/p/w500${widget.matchedMovie.posterPath}',
              height: 300,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const WelcomeScreen()));
              },
              child: const Text('Back to Movie Selection'),
            ),
          ],
        ),
      ),
    );
  }
}
