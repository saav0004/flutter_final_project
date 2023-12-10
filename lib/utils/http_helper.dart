import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// import provider
import 'package:final_project/provider/my_data_model.dart';

// URL
//https://api.themoviedb.org/3/movie/popular?api_key=516113cfd57ae5d6cb785a6c5bb76fc0

// code from my last assignment
class HttpHelper {
  static Future<List<Movie>> fetch(String url) async {
    Uri uri = Uri.parse(url);
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      dynamic data = jsonDecode(resp.body);
      List<dynamic> results = data['results'];
      // print(results);
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Did not get a valid response');
    }
  }

  // 20231210142709
// https://movie-night-api.onrender.com/start-session?device_id=1235123123

// {
//   "data": {
//     "message": "new session created.",
//     "code": "4674",
//     "session_id": "a055f804-1e9a-4a6e-94ee-d2ef8f5ec60e"
//   }
// }

  static Future<Session> fetchSession(String url) async {
    Uri uri = Uri.parse(url);
    http.Response resp = await http.get(uri);
    if (resp.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(resp.body);
      print(data);
      return Session.fromJson(data);
    } else {
      throw Exception('Did not get a valid response');
    }
  }
}

// Quote class
class Movie {
  late int id;
  late bool adult;
  late String backdropPath;
  late List<int> genreIds;
  late String originalLanguage;
  late String originalTitle;
  late String overview;
  late double popularity;
  late String posterPath;
  late DateTime releaseDate;
  late String title;
  late bool video;
  late double voteAverage;
  late int voteCount;

// named constructor
  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = DateTime.parse(json['release_date']);
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}

class Session {
  String message;
  String code;
  String sessionId;

  Session({required this.message, required this.code, required this.sessionId});

// named constructor
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      message: json['data']['message'],
      code: json['data']['code'],
      sessionId: json['data']['session_id'],
    );
  }
}
