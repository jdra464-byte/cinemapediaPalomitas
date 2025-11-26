import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class FirestoreRepositoryImpl extends LocalStorageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper para obtener la colección del usuario actual
  CollectionReference get _favoritesCollection {
    final uid = _auth.currentUser?.uid;
    // Si no hay usuario, lanzamos error controlado (aunque el router lo debe evitar)
    if (uid == null) throw Exception('Usuario no logueado');
    return _firestore.collection('users').doc(uid).collection('favorites');
  }
  
  @override
  Future<bool> isMovieFavorite(int movieId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return false;
      
      final doc = await _favoritesCollection.doc(movieId.toString()).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final docRef = _favoritesCollection.doc(movie.id.toString());
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'overview': movie.overview,
        'voteAverage': movie.voteAverage,
        'releaseDate': movie.releaseDate.toIso8601String(),
        'popularity': movie.popularity,
        'isAdult': movie.adult,
        'originalLanguage': movie.originalLanguage,
        'originalTitle': movie.originalTitle,
        'video': movie.video,
        'voteCount': movie.voteCount,
        'genreIds': movie.genreIds,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    try {
      final snapshot = await _favoritesCollection
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final List<Movie> movies = [];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // 🛡️ Mapeo con conversión de tipos blindada
        movies.add(Movie(
          adult: data['isAdult'] ?? false,
          backdropPath: data['backdropPath'] ?? '',
          genreIds: List<String>.from(data['genreIds']?.map((e) => e.toString()) ?? []),
          id: data['id'] ?? 0,
          originalLanguage: data['originalLanguage'] ?? '',
          originalTitle: data['originalTitle'] ?? '',
          overview: data['overview'] ?? '',
          // 🔥 ARREGLO 1: Acepta int o double y lo convierte a double
          popularity: (data['popularity'] as num?)?.toDouble() ?? 0.0,
          posterPath: data['posterPath'] ?? '',
          releaseDate: DateTime.tryParse(data['releaseDate'] ?? '') ?? DateTime.now(),
          title: data['title'] ?? 'Sin Título',
          video: data['video'] ?? false,
          // 🔥 ARREGLO 2: Acepta int o double y lo convierte a double
          voteAverage: (data['voteAverage'] as num?)?.toDouble() ?? 0.0,
          voteCount: (data['voteCount'] as num?)?.toInt() ?? 0,
        ));
      }
      return movies;

    } catch (e) {
      print("❌ Error general al cargar favoritos: $e");
      // Si falla, al menos la app no se crashea y muestra una lista vacía
      return []; 
    }
  }
}