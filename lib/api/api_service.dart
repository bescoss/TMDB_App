import 'dart:convert';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/review.dart';
import 'package:movies_app/models/actors.dart';
import 'package:movies_app/models/actors_id.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(20).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor_id>?> getCustomActors(List<Actor> actors) async {
    List<Actor_id> customActors = [];
    try {
      for (var actor in actors) {
        http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/${actor.id.toString()}?api_key=${Api.apiKey}&language=en-US&page=1',
        ));
        var res = jsonDecode(response.body);
        var actorMap =
            res; // Access the actor directly, assuming it's under "results"
        customActors.add(Actor_id.fromMap2(actorMap));
      }
      return customActors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(20).forEach(
            (m) => actors.add(
              Actor.fromMap(m),
            ),
          );
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getTrendingActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}trending/person/day?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(20).forEach(
            (m) => actors.add(
              Actor.fromMap(m),
            ),
          );
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getBestMoviesFromActor(Actor_id actor) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/${actor.id}/combined_credits?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['cast'].take(10).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(20).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor_id>?> getSearchedActors(String query) async {
    List<Actor_id> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/person?api_key=YourApiKey&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => actors.add(
          Actor_id.fromMap2(m),
        ),
      );
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }
}
