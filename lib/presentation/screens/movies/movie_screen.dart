

import 'package:cinemapedia/domain/entities/movies.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetail(movie: movie),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDetail extends StatelessWidget {
  final Movie movie;

  const _MovieDetail({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  width: size.width*0.3,
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: (size.width-40)*0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender)=>Container(
                margin: EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(
                      gender,
                      style: TextStyle(color: Colors.black87),
                    ),
                    backgroundColor: Colors.blueGrey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                  ),
                ),
              ),
            ],
        ),
        ),
        SizedBox(height: 100),
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;

  _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      expandedHeight: size.height * 0.7,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.start,
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(movie.posterPath, fit: BoxFit.cover),
            ),
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87, Colors.black],
                    stops: [0.0, 0.9, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
