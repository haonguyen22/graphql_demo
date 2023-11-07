import 'package:graphql_demo/domain/entities/author.dart';
import 'package:graphql_demo/domain/entities/game.dart';

class Review {
  String? id;
  int? rating;
  String? content;
  Author? author;
  Game? game;

  Review({
    this.id,
    this.rating,
    this.content,
    this.author,
    this.game,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      content: json['content'],
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      game: json['game'] != null ? Game.fromJson(json['game']) : null,
    );
  }
}
