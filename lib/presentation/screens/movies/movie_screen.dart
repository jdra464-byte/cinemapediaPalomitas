import 'package:cinemapedia/domain/entities/movies.dart';
<<<<<<< HEAD
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_videos_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_cast_provider.dart';
import 'package:cinemapedia/presentation/screens/movies/trailer_player_screen.dart';
import 'package:cinemapedia/presentation/widgets/movies/comments_section.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_list_provider.dart';
import 'package:url_launcher/url_launcher.dart';
=======
import 'package:cinemapedia/domain/entities/actor.dart'; 
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_cast_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/comments_section.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart'; 
import 'package:cinemapedia/presentation/providers/storage/favorite_list_provider.dart';

>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
<<<<<<< HEAD
    ref.read(movieCastProvider.notifier).loadMovieCast(widget.movieId);
  }

  // Obtenemos el movieId de la clase MovieScreen
  String get movieId => widget.movieId;

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[movieId];
    final List<Actor> cast = ref.watch(movieCastProvider)[movieId] ?? [];
    // ❌ Se elimina la variable videosAsync de aquí para usarla dentro de _TrailerButton
=======
    ref.read(movieCastProvider.notifier).loadMovieCast(widget.movieId); 
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    final List<Actor> cast = ref.watch(movieCastProvider)[widget.movieId] ?? [];
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b

    if (movie == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Column(
                children: [
                  _MovieDetail(movie: movie, cast: cast),
                  // Sección de comentarios
<<<<<<< HEAD
                  CommentsSection(movieId: movie.id.toString()),
=======
                  CommentsSection(movieId: movie.id.toString()), 
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
                  const SizedBox(height: 50),
                ],
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
Future<void> launchYouTubeVideo(String videoId) async {
  final url = Uri.parse("https://www.youtube.com/watch?v=$videoId");

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'No se pudo abrir el video $videoId';
  }
}

// =========================================================================
// WIDGET PARA MOSTRAR EL DETALLE DE LA PELÍCULA Y EL REPARTO
// =========================================================================
class _MovieDetail extends StatelessWidget {
  final Movie movie;
  final List<Actor> cast;

  const _MovieDetail({required this.movie, required this.cast});
=======
class _MovieDetail extends StatelessWidget {
  final Movie movie;
  final List<Actor> cast; 

  const _MovieDetail({required this.movie, required this.cast}); 
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              // Póster de la película
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath, width: size.width * 0.3),
              ),
              const SizedBox(width: 10),
              // Título y descripción
=======
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(width: 10),
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
<<<<<<< HEAD
                    // Descripción de la película
                    Text(movie.overview),
                    // ❌ ELIMINADO: La lógica del botón estaba aquí, dentro de este Column limitado en ancho.
=======
                    Text(movie.overview),
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
                  ],
                ),
              ),
            ],
          ),
        ),
<<<<<<< HEAD

        // ⭐ AÑADIDO: El botón del tráiler ahora va aquí, debajo del Row del póster y la descripción.
        _TrailerButton(movieId: movie.id.toString()),

=======
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: [
<<<<<<< HEAD
              ...movie.genreIds.map(
                (gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(
                      gender,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    backgroundColor: Colors.blueGrey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
=======
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(
                        gender,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      backgroundColor: Colors.blueGrey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), 
                      ),
                    ),
                  )),
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
            ],
          ),
        ),

        if (cast.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(10),
<<<<<<< HEAD
            child: Text('Reparto Principal', style: textStyle.titleLarge),
=======
            child: Text(
              'Reparto Principal',
              style: textStyle.titleLarge,
            ),
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: (context, index) {
                final actor = cast[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(actor.fullProfilePath),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        actor.name,
                        style: textStyle.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        actor.character,
                        style: textStyle.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

<<<<<<< HEAD
// =========================================================================
// NUEVO WIDGET PARA EL BOTÓN DEL TRÁILER (ConsumerWidget)
// =========================================================================
class _TrailerButton extends ConsumerWidget {
  final String movieId;

  const _TrailerButton({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Consumimos el provider aquí
    final videosAsync = ref.watch(movieVideosProvider(movieId));

    return videosAsync.when(
      data: (videos) {
        if (videos.isEmpty) return const SizedBox();

        // Aseguramos que solo usamos el primer video
        final trailer = videos.first;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrailerPlayerScreen(videoId: trailer.key),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Ver trailer'),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(15.0),
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox(),
    );
  }
}

// =========================================================================
// WIDGET SLIVER APP BAR
// =========================================================================
class _CustomSliverAppBar extends ConsumerWidget {
=======
class _CustomSliverAppBar extends ConsumerWidget { 
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
<<<<<<< HEAD
  Widget build(BuildContext context, WidgetRef ref) {
=======
  Widget build(BuildContext context, WidgetRef ref) { 
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
    // Escuchamos si es favorita
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            // 1. Toggle en DB
<<<<<<< HEAD
            await ref
                .read(localStorageRepositoryProvider)
                .toggleFavorite(movie);
            ref.invalidate(favoriteMoviesProvider);

=======
            await ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
            ref.invalidate(favoriteMoviesProvider);
            
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
            // 3. Invalida el icono actual
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
<<<<<<< HEAD
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border),
            error: (_, __) => const Icon(Icons.error_outline),
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
=======
            data: (isFavorite) => isFavorite 
                ? const Icon(Icons.favorite, color: Colors.red) 
                : const Icon(Icons.favorite_border),
            error: (_, __) => const Icon(Icons.error_outline), 
            loading: () => const CircularProgressIndicator(strokeWidth: 2), 
          ),
        )
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return child;
                },
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.2],
                    colors: [Colors.black54, Colors.transparent],
<<<<<<< HEAD
                  ),
                ),
=======
                  )
                )
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
<<<<<<< HEAD
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.8, 1.0],
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
=======
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.8, 1.0],
                        colors: [Colors.transparent, Colors.black87])),
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
              ),
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
