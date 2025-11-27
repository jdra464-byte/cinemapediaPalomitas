import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showSearchIcon;
  final String? title;

  const CustomAppbar({
    super.key,
    this.showBackButton = false,
    this.showSearchIcon = true,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final text = title ?? 'Cinemapedia';

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                ),
              Text(text, style: titleStyle),
              const Spacer(),
              if (showSearchIcon)
                IconButton(
                  onPressed: () {
                    // Navegar a pantalla de búsqueda
                    context.push('/search');
                  },
                  icon: const Icon(Icons.search_outlined),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
