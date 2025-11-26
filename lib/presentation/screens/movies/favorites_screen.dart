import 'package:cinemapedia/presentation/providers/storage/favorite_list_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  static const name = 'favorites-screen';

  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // No llamamos a la carga aquí para evitar conflictos.
  }

  // ✅ SOLUCIÓN CRÍTICA: Deferir la acción de carga para que ocurra después del build.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Esto asegura que la acción se ejecute después del primer frame y cada vez que
    // la pantalla reciba el foco (al navegar de vuelta desde MovieScreen).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAndLoad();
    });
  }

  void _refreshAndLoad() async {
    // Si la pantalla ya está en proceso de carga, salimos.
    if (isLoading) return;
    
    // Ponemos el loader y notificamos a la UI
    isLoading = true;
    setState(() {}); 

    // 1. Forzamos el refresh que limpia el Notifier y hace la consulta a Firebase
    final notifier = ref.read(favoriteMoviesProvider.notifier);
    await notifier.refreshFavorites(); 
    
    if (mounted) {
      // 2. Verificamos el resultado del estado
      final favoriteMovies = ref.read(favoriteMoviesProvider);
      
      isLoading = false;
      isLastPage = favoriteMovies.isEmpty;
      setState(() {}); // Forzamos el rebuild final con la data
    }
  }

  void _loadNextPage() async {
    if (isLoading || isLastPage) return;
    
    isLoading = true;
    // loadNextPage retorna la lista de nuevas películas, que usamos para verificar el final
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
    if (mounted) setState(() {});
  }

  // ... (El resto del código del EmptyState sigue igual) ...
  Widget _buildEmptyState(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: colors.primary),
          const SizedBox(height: 20),
          Text('¡Aún no tienes favoritos!', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text('Dale al corazón en las películas que te gusten.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
            label: const Text('Ir a la Home'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider);
    
    // Mostrar loader solo si está vacío y cargando
    if (favoriteMovies.isEmpty && isLoading) {
      return const FullScreenLoader();
    }
    
    if (favoriteMovies.isEmpty && !isLoading) {
      return _buildEmptyState(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), 
          onPressed: () => context.go('/'),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
            _loadNextPage();
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2/3,
          ),
          itemCount: favoriteMovies.length,
          itemBuilder: (context, index) {
            final movie = favoriteMovies[index];
            return GestureDetector(
              onTap: () => context.push('/movie/${movie.id}'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: Colors.grey[200]);
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}