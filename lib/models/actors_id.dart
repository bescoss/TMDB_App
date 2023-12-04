// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore: camel_case_types
class Actor_id {
  int id;
  double popularity;
  String biography;
  String birthday;
  String imdb_id;
  String name;
  String place_of_birth;
  String profile_path_img;
  Actor_id({
    required this.id,
    required this.popularity,
    required this.biography,
    required this.birthday,
    required this.imdb_id,
    required this.name,
    required this.place_of_birth,
    required this.profile_path_img,
  });

  factory Actor_id.fromMap2(Map<String, dynamic> map) {
    return Actor_id(
      id: map['id'] as int,
      biography: map['biography'] ?? '',
      birthday: map['birthday'] ?? '',
      imdb_id: map['imdb_id'] ?? '',
      name: map['name'] ?? '',
      place_of_birth: map['place_of_birth'] ?? '',
      popularity: map['popularity'] as double,
      profile_path_img: map['profile_path'] ?? '',
    );
  }

  factory Actor_id.fromJson(String source) =>
      Actor_id.fromMap2(json.decode(source));
}
