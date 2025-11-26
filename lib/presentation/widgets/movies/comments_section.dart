import 'package:cinemapedia/presentation/providers/auth/auth_provider.dart';
import 'package:cinemapedia/presentation/providers/comments/comments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CommentsSection extends ConsumerStatefulWidget {
  final String movieId;
  const CommentsSection({super.key, required this.movieId});

  @override
  CommentsSectionState createState() => CommentsSectionState();
}

class CommentsSectionState extends ConsumerState<CommentsSection> {
  final _commentController = TextEditingController();

  void _submitComment() {
    final user = ref.read(authStateProvider).value;
    if (user == null || _commentController.text.trim().isEmpty) return;

    // ✅ Usamos el nombre de Google si existe, o la primera parte del correo
    final nameToShow = user.displayName ?? user.email!.split('@')[0];

<<<<<<< HEAD
    ref
        .read(commentsRepositoryProvider)
        .addComment(
=======
    ref.read(commentsRepositoryProvider).addComment(
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
          movieId: widget.movieId,
          userId: user.uid,
          userName: nameToShow,
          userEmail: user.email,
          userPhotoUrl: user.photoURL,
          text: _commentController.text.trim(),
        );

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final commentsAsyncValue = ref.watch(
      commentsByMovieProvider(widget.movieId),
    );
=======
    final commentsAsyncValue = ref.watch(commentsByMovieProvider(widget.movieId));
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
    final user = ref.watch(authStateProvider).value;
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          const Text(
            'Comentarios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

=======
          const Text('Comentarios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
          if (user != null)
            Row(
              children: [
                // Tu foto actual al escribir
                CircleAvatar(
                  radius: 18,
<<<<<<< HEAD
                  backgroundImage:
                      (user.photoURL != null && user.photoURL!.isNotEmpty)
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: (user.photoURL == null || user.photoURL!.isEmpty)
                      ? Text(
                          user.email != null && user.email!.isNotEmpty
                              ? user.email![0].toUpperCase()
                              : '?',
                        )
=======
                  backgroundImage: (user.photoURL != null && user.photoURL!.isNotEmpty)
                      ? NetworkImage(user.photoURL!) 
                      : null,
                  child: (user.photoURL == null || user.photoURL!.isEmpty)
                      ? Text(user.email != null && user.email!.isNotEmpty 
                          ? user.email![0].toUpperCase() 
                          : '?') 
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu opinión...',
                      border: OutlineInputBorder(),
<<<<<<< HEAD
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
=======
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _submitComment,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
<<<<<<< HEAD
                ),
=======
                )
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
              ],
            )
          else
            const Center(child: Text('Inicia sesión para comentar')),

          const SizedBox(height: 20),

          commentsAsyncValue.when(
            data: (comments) {
<<<<<<< HEAD
              if (comments.isEmpty)
                return const Center(child: Text('Sé el primero en comentar.'));

=======
              if (comments.isEmpty) return const Center(child: Text('Sé el primero en comentar.'));
              
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //  FOTO DE PERFIL (CORREGIDO AQUÍ)
                          CircleAvatar(
                            radius: 20,
                            // Verificamos que la URL no sea nula Y no esté vacía
<<<<<<< HEAD
                            backgroundImage:
                                (comment.userPhotoUrl != null &&
                                    comment.userPhotoUrl!.isNotEmpty)
                                ? NetworkImage(comment.userPhotoUrl!)
                                : null,
                            // Si no hay foto, ponemos la letra
                            child:
                                (comment.userPhotoUrl == null ||
                                    comment.userPhotoUrl!.isEmpty)
                                ? Text(
                                    // CORRECCIÓN PRINCIPAL: Verificamos si hay nombre antes de pedir el índice [0]
                                    comment.userName.trim().isNotEmpty
                                        ? comment.userName
                                              .trim()[0]
                                              .toUpperCase()
                                        : '?', // Letra por defecto si no tiene nombre
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),

=======
                            backgroundImage: (comment.userPhotoUrl != null && comment.userPhotoUrl!.isNotEmpty)
                                ? NetworkImage(comment.userPhotoUrl!) 
                                : null,
                            // Si no hay foto, ponemos la letra
                            child: (comment.userPhotoUrl == null || comment.userPhotoUrl!.isEmpty)
                                ? Text(
                                    // CORRECCIÓN PRINCIPAL: Verificamos si hay nombre antes de pedir el índice [0]
                                    comment.userName.trim().isNotEmpty
                                        ? comment.userName.trim()[0].toUpperCase()
                                        : '?', // Letra por defecto si no tiene nombre
                                  ) 
                                : null,
                          ),
                          const SizedBox(width: 12),
                          
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  NOMBRE Y FECHA
                                Row(
<<<<<<< HEAD
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      comment.userName.isNotEmpty
                                          ? comment.userName
                                          : 'Anónimo', // Protección extra en el nombre completo
                                      style: textStyles.titleSmall,
                                    ),
                                    Text(
                                      DateFormat.MMMd().format(
                                        comment.timestamp,
                                      ),
                                      style: textStyles.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                //  CORREO
                                if (comment.userEmail != null)
                                  Text(
                                    comment.userEmail!,
                                    style: textStyles.bodySmall?.copyWith(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),

                                const SizedBox(height: 6),

                                //   COMENTARIO
                                Text(
                                  comment.text,
                                  style: textStyles.bodyMedium,
                                ),
=======
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      comment.userName.isNotEmpty ? comment.userName : 'Anónimo', // Protección extra en el nombre completo
                                      style: textStyles.titleSmall
                                    ),
                                    Text(
                                      DateFormat.MMMd().format(comment.timestamp),
                                      style: textStyles.bodySmall?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                
                                //  CORREO 
                                if (comment.userEmail != null)
                                  Text(comment.userEmail!, style: textStyles.bodySmall?.copyWith(fontSize: 10, color: Colors.grey[600])),
                                
                                const SizedBox(height: 6),
                                
                                //   COMENTARIO
                                Text(comment.text, style: textStyles.bodyMedium),
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 12b3c65bda40581d2e39efcf101d45728f67431b
