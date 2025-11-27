import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/providers/movies/actor_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActorScreen extends ConsumerStatefulWidget {
  static const name = 'actor-screen';

  final String actorId;
  final String actorName;
  final String? profilePath;

  const ActorScreen({
    super.key,
    required this.actorId,
    required this.actorName,
    this.profilePath,
  });

  @override
  ActorScreenState createState() => ActorScreenState();
}

class ActorScreenState extends ConsumerState<ActorScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(actorMoviesProvider.notifier).loadActorMovies(widget.actorId);
  }

  @override
  Widget build(BuildContext context) {
    final actorMoviesMap = ref.watch(actorMoviesProvider);
    final movies = actorMoviesMap[widget.actorId];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.actorName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: movies == null
          ? const Center(child: CircularProgressIndicator())
          : _ActorMoviesView(
              actorName: widget.actorName,
              profilePath: widget.profilePath,
              movies: movies,
            ),
    );
  }
}

class _ActorMoviesView extends StatelessWidget {
  final String actorName;
  final String? profilePath;
  final List<Movie> movies;

  const _ActorMoviesView({
    required this.actorName,
    required this.profilePath,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 16),
        // Cabecera con foto y nombre
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: (profilePath != null && profilePath!.isNotEmpty)
                  ? NetworkImage('https://image.tmdb.org/t/p/w500$profilePath')
                  : null,
              child: (profilePath == null || profilePath!.isEmpty)
                  ? Text(
                      actorName.isNotEmpty ? actorName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                actorName,
                style: textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Películas en las que participa',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  context.push('/movie/${movie.id}');
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.title,
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
