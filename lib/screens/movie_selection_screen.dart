import 'package:flutter/material.dart';
import 'package:final_project/provider/my_data_model.dart';
import 'package:final_project/screens/match_screen.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:provider/provider.dart';

//https://movie-night-api.onrender.com/vote-movie?session_id=$sessionID&movie_id=$movieID&vote=$vote

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({Key? key}) : super(key: key);

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  late Future<List<Movie>> movies;
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

    bool isMatch = false;

    // PROVIDER
    var provider = context.read<MyDataModel>();

    String sessionID = provider.sessionId;
    String voteURL =
        "https://movie-night-api.onrender.com/vote-movie?session_id=$sessionID";

    //https://movie-night-api.onrender.com/vote-movie?session_id=$sessionID&movie_id=$movieID&vote=$vote

    isMatch = provider.isMatch;

    if (isMatch == true) {
      return const MatchScreen();
    }

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
          var movieList = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Movie selection screen'),
            ),
            body: ListView.builder(
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey<int>(movieList[index].id),
                  onDismissed: (DismissDirection direction) async {
                    if (direction == DismissDirection.endToStart) {
                      //&movie_id=$movieID&vote=$vote

                      String movieID = movieList[index].id.toString();
                      String vote = 'false';

                      var finalURL = voteURL + "&movie_id=$movieID&vote=$vote";

                      var result = await HttpHelper.voteSession(finalURL);

                      direction = DismissDirection.endToStart;
                    } else if (direction == DismissDirection.startToEnd) {
                      // GOOD VOTE
                      String movieID = movieList[index].id.toString();
                      String vote = 'true';
                      var finalURL = voteURL + "&movie_id=$movieID&vote=$vote";

                      var result = await HttpHelper.voteSession(finalURL);

                      provider.setIsMatch(result.match);

                      direction = DismissDirection.startToEnd;
                    }
                  },
                  background: Container(
                    color: Colors.green,
                    child: const Icon(Icons.check),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  child: ListTile(
                    title: Text(
                      movieList[index].title,
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
