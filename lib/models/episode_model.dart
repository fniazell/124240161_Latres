class EpisodeModel {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    this.characters = const [],
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? 'Unknown Episode',
      airDate: json['air_date'] as String? ?? 'Unknown Date',
      episode: json['episode'] as String? ?? 'Unknown Code',
      characters: json['characters'] != null
          ? List<String>.from((json['characters'] as List).map((e) => e.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': episode,
      'characters': characters,
    };
  }
}

