import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
<<<<<<< HEAD
import 'package:cinemapedia/domain/entities/movie_video.dart';
=======
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
<<<<<<< HEAD
import 'package:cinemapedia/infrastructure/mappers/movie_video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_credits.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart'
    as movie_details; // ✅ ALIAS
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos_response.dart';
=======
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_credits.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart' as movie_details; // ✅ ALIAS
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
import 'package:cinemapedia/infrastructure/models/moviedb/search_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      '/movie/upcoming',
      queryParameters: {'page': page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200)
      throw Exception('Movie with id: $id not found');

<<<<<<< HEAD
    final movieDetails = movie_details.MovieDetails.fromJson(
      response.data,
    ); // ✅ USAR ALIAS
=======
    final movieDetails = movie_details.MovieDetails.fromJson(response.data); // ✅ USAR ALIAS
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b

    final movie = MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }

  @override
  Future<List<Actor>> getMovieCast(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
<<<<<<< HEAD

=======
    
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
    if (response.statusCode != 200) {
      throw Exception('Error al obtener el reparto');
    }

    final movieCredits = MovieCredits.fromJson(response.data);
<<<<<<< HEAD

    final List<Actor> actors = movieCredits.cast
        .take(10)
        .map(
          (actor) => Actor(
            id: actor.id,
            name: actor.name,
            character: actor.character,
            profilePath: actor.profilePath,
          ),
        )
=======
    
    final List<Actor> actors = movieCredits.cast
        .take(10)
        .map((actor) => Actor(
              id: actor.id,
              name: actor.name,
              character: actor.character,
              profilePath: actor.profilePath,
            ))
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
        .toList();

    return actors;
  }

  @override
  Future<List<SearchResult>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    final response = await dio.get(
      '/search/multi',
<<<<<<< HEAD
      queryParameters: {'query': query, 'page': page, 'include_adult': false},
=======
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': false,
      },
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
    );

    if (response.statusCode != 200) {
      throw Exception('Error en la búsqueda');
    }

    final searchResponse = SearchResponse.fromJson(response.data);
<<<<<<< HEAD

    final List<SearchResult> results = searchResponse.results
        .where((item) => item.mediaType == 'movie' || item.mediaType == 'tv')
        .map(
          (item) => SearchResult(
            id: item.id,
            title: item.title,
            posterPath: item.posterPath,
            backdropPath: item.backdropPath,
            mediaType: item.mediaType ?? 'movie',
            voteAverage: item.voteAverage,
            releaseDate: item.releaseDate,
            overview: item.overview,
          ),
        )
=======
    
    final List<SearchResult> results = searchResponse.results
        .where((item) => item.mediaType == 'movie' || item.mediaType == 'tv')
        .map((item) => SearchResult(
              id: item.id,
              title: item.title,
              posterPath: item.posterPath,
              backdropPath: item.backdropPath,
              mediaType: item.mediaType ?? 'movie',
              voteAverage: item.voteAverage,
              releaseDate: item.releaseDate,
              overview: item.overview,
            ))
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
        .toList();

    return results;
  }

  @override
  Future<List<Genre>> getMovieGenres() async {
    final response = await dio.get('/genre/movie/list');

    if (response.statusCode != 200) {
      throw Exception('Error al obtener géneros');
    }

    final genresResponse = GenresResponse.fromJson(response.data);
<<<<<<< HEAD

    final List<Genre> genres = genresResponse.genres
        .map((genre) => Genre(id: genre.id, name: genre.name))
=======
    
    final List<Genre> genres = genresResponse.genres
        .map((genre) => Genre(
              id: genre.id,
              name: genre.name,
            ))
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
        .toList();

    return genres;
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final response = await dio.get(
      '/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'page': page,
        'sort_by': 'popularity.desc',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener películas del género');
    }

    return _jsonToMovies(response.data);
  }
<<<<<<< HEAD

  @override
  Future<List<MovieVideo>> getMovieVideos(String movieId) async {
    final response = await dio.get('/movie/$movieId/videos');

    final videosResponse = MovieDbVideosResponse.fromJson(response.data);
    final videos = videosResponse.results
        .map((e) => MovieVideoMapper.movieDBToEntity(e))
        .where((v) => v.isTrailer)
        .toList();

    return videos;
  }
}
=======
}
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
