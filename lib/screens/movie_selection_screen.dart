import 'package:flutter/material.dart';
import 'package:final_project/utils/http_helper.dart';
import 'dart:math' as math;

// swiper card
import 'package:swiping_card_deck/swiping_card_deck.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  late Future<List<Movie>> movies;
  late List<Movie> movieList;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    movies = fetchMovies(currentPage);
  }

  Future<List<Movie>> fetchMovies(int page) async {
    String url =
        'https://api.themoviedb.org/3/movie/popular?api_key=516113cfd57ae5d6cb785a6c5bb76fc0&page=$page';
    List<Movie> result = await HttpHelper.fetch(url);

    // Increment the currentPage after using it in the URL
    currentPage++;

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: movies,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("No movies available");
        } else {
          movieList = snapshot.data!;
          final SwipingCardDeck deck = SwipingCardDeck(
            cardDeck: getCardDeck(),
            onDeckEmpty: () async {
              Text("No more movies available");
              print("object");

              List<Movie> nextPageMovies = await fetchMovies(currentPage);
              if (nextPageMovies.isNotEmpty) {
                print("asdasdasda");
                setState(
                  () {
                    movieList.addAll(nextPageMovies);
                  },
                );
              }
            },
            onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
            onRightSwipe: (Card card) => debugPrint("Swiped right!"),
            cardWidth: 200,
            swipeThreshold: MediaQuery.of(context).size.width / 3,
            minimumVelocity: 1000,
            rotationFactor: 0.8 / 3.14,
            swipeAnimationDuration: const Duration(milliseconds: 100),
            disableDragging: false,
          );

          return Scaffold(
            appBar: AppBar(
              title: const Text('Movie selection screen'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  deck,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        iconSize: 30,
                        color: Colors.red,
                        onPressed: deck.animationActive
                            ? null
                            : () => deck.swipeLeft(),
                      ),
                      const SizedBox(width: 40),
                      IconButton(
                        icon: const Icon(Icons.check),
                        iconSize: 30,
                        color: Colors.green,
                        onPressed: deck.animationActive
                            ? null
                            : () => deck.swipeRight(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  List<Card> getCardDeck() {
    return movieList.map((movie) {
      return Card(
        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 3, // spread radius
                blurRadius: 10, // blur radius
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              // network image with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                  height: 550,
                  width: 350,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: 150,
                child: Text(
                  maxLines: 2,
                  movie.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
