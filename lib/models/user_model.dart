class UserModel {
  final int? id;
  final String name;
  final String username;
  final String passwordHash;

  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.passwordHash,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'username': username,
      'passwordHash': passwordHash,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      passwordHash: map['passwordHash'] ?? '',
    );
  }
}

