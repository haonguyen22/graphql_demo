import 'package:graphql_demo/domain/entities/review.dart';

class Game {
  String? id;
  String? title;
  List<String>? platform;
  List<Review>? reviews;

  Game({
    this.id,
    this.title,
    this.platform,
    this.reviews,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      platform:
          json['platform'] != null ? List<String>.from(json['platform']) : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List).map((i) => Review.fromJson(i)).toList()
          : null,
    );
  }
}
