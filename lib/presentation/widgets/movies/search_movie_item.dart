import 'package:cinemapedia/domain/entities/search_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchMovieItem extends StatelessWidget {
  final SearchResult result;

  const SearchMovieItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return ListTile(
      // ✅ IMAGEN (Con protección para cuando no hay foto)
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          result.fullPosterPath,
          width: 50,
          height: 75,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 75,
              color: Colors.grey[300],
              // Icono diferente si es persona o película
              child: Icon(
                result.mediaType == 'person'
                    ? Icons.person
                    : Icons.movie_outlined,
                color: Colors.grey[600],
              ),
            );
          },
        ),
      ),

      // ✅ TÍTULO
      title: Text(
        result.title,
        style: textStyle.titleMedium,
        maxLines: 2, // Permitir 2 líneas para nombres largos
        overflow: TextOverflow.ellipsis,
      ),

      // ✅ SUBTÍTULO (Etiqueta de tipo + Descripción)
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          // Etiqueta de tipo (Negrita o color distintivo)
          if (result.mediaType == 'movie')
            Text(
              'Película',
              style: textStyle.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),

          if (result.mediaType == 'tv')
            Text(
              'Serie',
              style: textStyle.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

          if (result.mediaType == 'person')
            Text(
              'Actor',
              style: textStyle.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

          const SizedBox(height: 2),

          // Descripción / Overview (Si existe)
          if (result.overview != null && result.overview!.isNotEmpty)
            Text(
              result.overview!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle.bodySmall,
            ),
        ],
      ),

      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),

      // ✅ NAVEGACIÓN ACTUALIZADA
      onTap: () {
        // Navegación a Película
        if (result.mediaType == 'movie') {
          context.push('/movie/${result.id}');
        }

        // Navegación a Actor (NUEVO)
        if (result.mediaType == 'person') {
          context.push(
            '/actor/${result.id}',
            extra: {'name': result.title, 'profilePath': result.posterPath},
          );
        }

        // TODO: Agregar navegación para Series (tv) en el futuro
      },
    );
  }
}
