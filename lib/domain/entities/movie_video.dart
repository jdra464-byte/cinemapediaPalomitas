class MovieVideo {
  final String id;
  final String name;
  final String type;
  final String site;
  final String key; // YouTube video ID

  MovieVideo({
    required this.id,
    required this.name,
    required this.type,
    required this.site,
    required this.key,
  });

  bool get isTrailer => type == 'Trailer' && site == 'YouTube';
}
