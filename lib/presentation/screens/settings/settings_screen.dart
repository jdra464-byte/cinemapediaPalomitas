import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static const name = 'settings-screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Configuración general',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma de la app'),
            subtitle: const Text('Aquí después agregaremos el cambio de idioma'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Aquí podremos cambiar entre Español / Inglés más adelante.',
                  ),
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones'),
            subtitle: const Text('Ejemplo de opción, aún sin lógica de backend'),
            value: true,
            onChanged: (_) {
              // Aquí luego puedes guardar el valor en un provider o en Firestore
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de la app'),
            subtitle: const Text('Información básica de la aplicación'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Cinemapedia',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
