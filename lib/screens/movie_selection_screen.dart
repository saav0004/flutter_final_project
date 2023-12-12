import 'package:flutter/material.dart';
import 'package:final_project/utils/http_helper.dart';

// swipe card package
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

  Future<List<Movie>> fetchMovies(int page) async {
    String url =
        'https://api.themoviedb.org/3/movie/popular?api_key=516113cfd57ae5d6cb785a6c5bb76fc0&page=$page';
    List<Movie> result = await HttpHelper.fetch(url);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    movies = fetchMovies(currentPage);
    return FutureBuilder<List<Movie>>(
      future: movies,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          movieList = snapshot.data!;
          SwipingCardDeck deck = SwipingCardDeck(
            cardDeck: getCardDeck(),
            onDeckEmpty: () async {
              setState(() {
                currentPage++;
              });
              const Text("No more movies available");

              List<Movie> nextPageMovies = await fetchMovies(currentPage + 1);
              if (nextPageMovies.isNotEmpty) {
                setState(
                  () {
                    movieList = nextPageMovies;
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
            swipeAnimationDuration: const Duration(milliseconds: 300),
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
        color: Colors.white,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 550,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/original/${movie.posterPath}'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(4, 4, 4, 0),
                        Color.fromRGBO(4, 4, 4, 0.8),
                        Color.fromRGBO(4, 4, 4, 0.9),
                        Color.fromRGBO(4, 4, 4, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                maxLines: 2,
                                movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              movie.releaseDate.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rate,
                                  color: Colors.yellow,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  movie.voteAverage.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
