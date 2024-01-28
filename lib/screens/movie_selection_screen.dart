import 'package:flutter/material.dart';
import 'package:final_project/provider/my_data_model.dart';
import 'package:final_project/screens/match_screen.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return const DismissibleContainer();
  }
}

class DismissibleContainer extends StatefulWidget {
  const DismissibleContainer({super.key});

  @override
  State<DismissibleContainer> createState() => _DismissibleContainerState();
}

class _DismissibleContainerState extends State<DismissibleContainer> {
  int currentPage = 1;
  List<Movie> movieList = [];
  int currentMovieIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchMovies(currentPage);
  }

  Future<void> fetchMovies(int page) async {
    String url =
        'https://api.themoviedb.org/3/movie/popular?api_key=516113cfd57ae5d6cb785a6c5bb76fc0&page=$page';
    List<Movie> result = await HttpHelper.fetch(url);
    setState(() {
      movieList = result;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<MyDataModel>();
    String sessionID = provider.sessionId;
    String voteURL =
        "https://movie-night-api.onrender.com/vote-movie?session_id=$sessionID";

    if (movieList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Movie selection screen'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie selection screen'),
      ),
      body: Dismissible(
        key: ValueKey<int>(movieList[currentMovieIndex].id),
        onDismissed: (DismissDirection direction) async {
          if (direction == DismissDirection.endToStart) {
            // Handle left swipe (dislike)
            String movieID = movieList[currentMovieIndex].id.toString();
            String vote = 'false';
            var finalURL = "$voteURL&movie_id=$movieID&vote=$vote";
            var result = await HttpHelper.voteSession(finalURL);

            int matchedMovie = int.parse(result.movieId);
            // find the matched movie in the array
            var matchedMovieObject =
                movieList.firstWhere((element) => element.id == matchedMovie);
            // send me to the match screen if match is true
            if (result.match == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchScreen(
                    matchedMovie: matchedMovieObject,
                  ),
                ),
              );
            }
          } else if (direction == DismissDirection.startToEnd) {
            // Handle right swipe (like)
            String movieID = movieList[currentMovieIndex].id.toString();
            String vote = 'true';
            var finalURL = "$voteURL&movie_id=$movieID&vote=$vote";
            var result = await HttpHelper.voteSession(finalURL);

            int matchedMovie = int.parse(result.movieId);
            // find the matched movie in the array
            var matchedMovieObject =
                movieList.firstWhere((element) => element.id == matchedMovie);
            // send to the match screen if match is true
            if (result.match == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchScreen(
                    matchedMovie: matchedMovieObject,
                  ),
                ),
              );
            }
          }

          // Move to the next movie
          setState(() {
            currentMovieIndex = (currentMovieIndex + 1) % movieList.length;
          });
        },
        background: Container(
          color: Colors.green,
          child: const Icon(Icons.check),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          child: const Icon(Icons.delete),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              movieList[currentMovieIndex].title,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                height: 450,
                child: FadeInImage.memoryNetwork(
                    fadeInDuration: const Duration(
                      milliseconds: 100,
                    ),
                    fit: BoxFit.contain,
                    placeholder: kTransparentImage,
                    image:
                        'https://image.tmdb.org/t/p/w500${movieList[currentMovieIndex].posterPath}'))
          ],
        ),
      ),
    );
  }
}


//  ListTile(
              
//               title: Text(
//                 movieList[currentMovieIndex].title,
//               ),