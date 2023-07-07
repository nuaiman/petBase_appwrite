import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String city;
  final String country;
  final String imageUrl;
  final double lat;
  final double lon;
  final List<String> pets;
  final List<String> likes;
  final List<String> conversations;
  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.country,
    required this.imageUrl,
    required this.lat,
    required this.lon,
    required this.pets,
    required this.likes,
    required this.conversations,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? city,
    String? country,
    String? imageUrl,
    double? lat,
    double? lon,
    List<String>? pets,
    List<String>? likes,
    List<String>? conversations,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      pets: pets ?? this.pets,
      likes: likes ?? this.likes,
      conversations: conversations ?? this.conversations,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'city': city});
    result.addAll({'country': country});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'lat': lat});
    result.addAll({'lon': lon});
    result.addAll({'pets': pets});
    result.addAll({'likes': likes});
    result.addAll({'conversations': conversations});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      lon: map['lon']?.toDouble() ?? 0.0,
      pets: List<String>.from(map['pets']),
      likes: List<String>.from(map['likes']),
      conversations: List<String>.from(map['conversations']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phoneNumber: $phoneNumber, city: $city, country: $country, imageUrl: $imageUrl, lat: $lat, lon: $lon, pets: $pets, likes: $likes, conversations: $conversations)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.city == city &&
        other.country == country &&
        other.imageUrl == imageUrl &&
        other.lat == lat &&
        other.lon == lon &&
        listEquals(other.pets, pets) &&
        listEquals(other.likes, likes) &&
        listEquals(other.conversations, conversations);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        city.hashCode ^
        country.hashCode ^
        imageUrl.hashCode ^
        lat.hashCode ^
        lon.hashCode ^
        pets.hashCode ^
        likes.hashCode ^
        conversations.hashCode;
  }
}
