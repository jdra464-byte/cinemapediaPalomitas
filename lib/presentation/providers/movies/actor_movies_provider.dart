import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final actorMoviesProvider =
    StateNotifierProvider<ActorMoviesNotifier, Map<String, List<Movie>>>((ref) {
      final getMoviesByActor = ref
          .watch(moviesRepositoryProvider)
          .getMoviesByActor;
      return ActorMoviesNotifier(getMoviesByActor: getMoviesByActor);
    });

typedef GetMoviesByActorCallback = Future<List<Movie>> Function(String actorId);

class ActorMoviesNotifier extends StateNotifier<Map<String, List<Movie>>> {
  final GetMoviesByActorCallback getMoviesByActor;

  ActorMoviesNotifier({required this.getMoviesByActor}) : super({});

  Future<void> loadActorMovies(String actorId) async {
    if (state[actorId] != null) return;

    try {
      final movies = await getMoviesByActor(actorId);
      state = {...state, actorId: movies};
    } catch (e) {
      // Podrías loguear el error si lo necesitas
    }
  }
}
