import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie_video.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/genres_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_credits.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart'
    as movie_details; // ✅ ALIAS
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/search_response.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

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

    final movieDetails = movie_details.MovieDetails.fromJson(
      response.data,
    ); // ✅ USAR ALIAS

    final movie = MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }

  @override
  Future<List<Actor>> getMovieCast(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    if (response.statusCode != 200) {
      throw Exception('Error al obtener el reparto');
    }

    final movieCredits = MovieCredits.fromJson(response.data);

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
        .toList();

    return actors;
  }

  // ✅ MÉTODO MODIFICADO PARA INCLUIR ACTORES
  @override
  Future<List<SearchResult>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    final response = await dio.get(
      '/search/multi',
      queryParameters: {'query': query, 'page': page, 'include_adult': false},
    );

    if (response.statusCode != 200) {
      throw Exception('Error en la búsqueda');
    }

    final searchResponse = SearchResponse.fromJson(response.data);

    final List<SearchResult> results = searchResponse.results.map((item) {
      final mediaType = item.mediaType ?? 'movie';

      // ✅ Resultado de tipo PERSON (actor)
      if (mediaType == 'person') {
        return SearchResult(
          id: item.id,
          title: item.title, // La entidad maneja la lógica de name/title
          posterPath:
              item.posterPath ??
              item.profilePath, // Usar profilePath si posterPath es null
          backdropPath: item.backdropPath,
          mediaType: mediaType,
          voteAverage: null, // No aplica
          releaseDate: null, // No aplica
          overview: item.overview,
        );
      }

      // ✅ Películas y series
      return SearchResult(
        id: item.id,
        title: item.title,
        posterPath: item.posterPath,
        backdropPath: item.backdropPath,
        mediaType: mediaType,
        voteAverage: item.voteAverage,
        releaseDate: item.releaseDate,
        overview: item.overview,
      );
    }).toList();

    return results;
  }

  @override
  Future<List<Genre>> getMovieGenres() async {
    final response = await dio.get('/genre/movie/list');

    if (response.statusCode != 200) {
      throw Exception('Error al obtener géneros');
    }

    final genresResponse = GenresResponse.fromJson(response.data);

    final List<Genre> genres = genresResponse.genres
        .map((genre) => Genre(id: genre.id, name: genre.name))
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

  @override
  Future<List<Movie>> getMoviesByActor(String actorId) async {
    final response = await dio.get('/person/$actorId/movie_credits');

    if (response.statusCode != 200) {
      throw Exception('Error al obtener películas del actor');
    }

    final List<dynamic> cast = response.data['cast'] ?? [];

    final List<Movie> movies = cast
        // Filtrar solo películas con póster válido
        .where(
          (item) =>
              item['poster_path'] != null &&
              (item['poster_path'] as String).isNotEmpty,
        )
        .map<Movie>((item) {
          // Ajustar datos para que MovieMovieDB.fromJson no truene
          final Map<String, dynamic> json = Map<String, dynamic>.from(item);

          json['genre_ids'] ??= <int>[];
          if (json['release_date'] == null ||
              (json['release_date'] as String).isEmpty) {
            // Valor por defecto si no trae fecha
            json['release_date'] = '1900-01-01';
          }

          final movieDb = MovieMovieDB.fromJson(json);
          return MovieMapper.movieDBToEntity(movieDb);
        })
        .toList();

    return movies;
  }

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
