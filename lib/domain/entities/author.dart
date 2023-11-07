import 'package:graphql_demo/domain/entities/review.dart';

class Author {
  String? id;
  String? name;
  bool? verified;
  List<Review>? reviews;

  Author({
    this.id,
    this.name,
    this.verified,
    this.reviews,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      verified: json['verified'],
      reviews: json['reviews'] != null
          ? (json['reviews'] as List).map((i) => Review.fromJson(i)).toList()
          : null,
    );
  }
}
