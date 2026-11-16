class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String originName;
  final String originUrl;
  final String locationName;
  final String locationUrl;
  final String image;
  final List<String> episode;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    this.originUrl = '',
    required this.locationName,
    this.locationUrl = '',
    required this.image,
    this.episode = const [],
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? 'Unknown',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Unknown',
      originName: (json['origin'] is Map) ? (json['origin']['name'] ?? 'Unknown') : (json['originName'] ?? 'Unknown'),
      originUrl: (json['origin'] is Map) ? (json['origin']['url'] ?? '') : (json['originUrl'] ?? ''),
      locationName: (json['location'] is Map) ? (json['location']['name'] ?? 'Unknown') : (json['locationName'] ?? 'Unknown'),
      locationUrl: (json['location'] is Map) ? (json['location']['url'] ?? '') : (json['locationUrl'] ?? ''),
      image: json['image'] as String? ?? '',
      episode: json['episode'] != null
          ? List<String>.from((json['episode'] as List).map((e) => e.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'originName': originName,
      'originUrl': originUrl,
      'locationName': locationName,
      'locationUrl': locationUrl,
      'image': image,
      'episode': episode,
    };
  }
}

