import 'package:cinemapedia/presentation/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  static const name = 'profile-screen';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);

    return userAsync.when(
      data: (user) {
        // Si por alguna razón no hay usuario, mándalo al login
        if (user == null) {
          Future.microtask(() => context.go('/login'));
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);
        final name = user.displayName ?? user.email?.split('@').first ?? 'Usuario';
        final email = user.email ?? 'Sin correo';
        final photoUrl = user.photoURL;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Perfil'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                      ? NetworkImage(photoUrl)
                      : null,
                  child: (photoUrl == null || photoUrl.isEmpty)
                      ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),

                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('Estado de correo'),
                  subtitle: Text(
                    user.emailVerified
                        ? 'Correo verificado'
                        : 'Tu correo aún no está verificado',
                  ),
                  trailing: Icon(
                    user.emailVerified
                        ? Icons.check_circle
                        : Icons.error_outline,
                    color: user.emailVerified ? Colors.green : Colors.orange,
                  ),
                  onTap: () async {
                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Se envió un correo de verificación.'),
                          ),
                        );
                      }
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.comment_outlined),
                  title: const Text('Comentarios'),
                  subtitle: const Text(
                    'Tus comentarios usan tu nombre de Google o tu correo.',
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Después podemos agregar aquí edición de nombre, foto, etc.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
