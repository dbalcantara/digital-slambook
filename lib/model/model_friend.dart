import 'dart:convert';

class Friend {
  String? id;
  String name;
  String nickname;
  String age;
  String isSingle;
  String happinessLevel;
  String superpower;
  String favoriteMotto;

  Friend({
    this.id,
    required this.name,
    required this.nickname,
    required this.age,
    required this.isSingle,
    required this.happinessLevel,
    required this.superpower,
    required this.favoriteMotto,
  });

  // Factory constructor to instantiate object from JSON format
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      age: json['age'],
      isSingle: json['isSingle'],
      happinessLevel: json['happinessLevel'],
      superpower: json['superpower'],
      favoriteMotto: json['favoriteMotto'],
    );
  }

  static List<Friend> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Friend>((dynamic d) => Friend.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'age': age,
      'isSingle': isSingle,
      'happinessLevel': happinessLevel,
      'superpower': superpower,
      'favoriteMotto': favoriteMotto,
    };
  }
}
