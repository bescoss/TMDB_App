import 'dart:convert';

class Actor {
  int id;

  Actor({
    required this.id,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'] as int,
    );
  }

  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));
}
