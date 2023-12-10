import 'package:flutter/material.dart';
import 'package:final_project/utils/http_helper.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  final Future<List<Movie>> movies = HttpHelper.fetch(
    'https://api.themoviedb.org/3/movie/popular?api_key=516113cfd57ae5d6cb785a6c5bb76fc0',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie selection screen'),
      ),
      body: Center(
        child: FutureBuilder<List<Movie>>(
          future: movies,
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].overview),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
