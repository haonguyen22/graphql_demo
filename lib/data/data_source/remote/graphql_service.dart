import 'package:graphql_demo/domain/entities/author.dart';
import 'package:graphql_demo/domain/entities/game.dart';
import 'package:graphql_demo/domain/entities/review.dart';
import 'package:graphql_demo/config/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();

  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<Author>?> getAuthors() async {
    try {
      QueryResult queryResult = await client.query(
        QueryOptions(
          document: gql(r""" 
        query Authors {
          authors {
            id
            name
            verified
            reviews {
              content
              rating  
              id
              game {
                title
                id
              }
            }
          }
        }
      """),
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      if (queryResult.hasException) {
        return [];
      } else {
        List<Author> authors = [];
        for (var item in queryResult.data!['authors']) {
          authors.add(Author.fromJson(item));
        }
        return authors;
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Game>?> getGames() async {
    try {
      QueryResult queryResult = await client.query(
        QueryOptions(
          document: gql(r""" 
        query Games {
          games {
            id
            title
            platform
            reviews {
              id
              rating
              content
              author {
                id
                name
              }
            }
          }
        }
      """),
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      if (queryResult.hasException) {
        return [];
      } else {
        List<Game> games = [];
        for (var item in queryResult.data!['games']) {
          games.add(Game.fromJson(item));
        }
        return games;
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Review>?> getReviews() async {
    try {
      QueryResult queryResult = await client.query(
        QueryOptions(
          document: gql(r""" 
        query Reviews {
          reviews {
            id
            rating
            content
            author {
              id
              name
            }
            game {
              id
              title
            }
          }
        }
      """),
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      if (queryResult.hasException) {
        return [];
      } else {
        List<Review> reviews = [];
        for (var item in queryResult.data!['reviews']) {
          reviews.add(Review.fromJson(item));
        }
        return reviews;
      }
    } catch (e) {
      return [];
    }
  }

  Future<Author?> getAuthor({required String id}) async {
    try {
      QueryResult queryResult = await client.query(
        QueryOptions(
          document: gql(r""" 
        query Author($authorId: ID!) {
          author(id: $authorId) {
            id
            name
            verified
            reviews {
              id
              rating
              content
              game {
                title
                id
              }
            }
          }
        }
      """),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            'authorId': id,
          },
        ),
      );
      if (queryResult.hasException) {
        return null;
      } else {
        Author author = Author.fromJson(queryResult.data!['author']);
        return author;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Game?> getGame({required String id}) async {
    try {
      QueryResult queryResult = await client.query(
        QueryOptions(
          document: gql(r""" 
        query Game($gameId: ID!) {
          game(id: $gameId) {
            id
            title
            platform
            reviews {
              rating
              content
              author {
                name
              }
              game {
                title
              }
            }
          }
        }
      """),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            'gameId': id,
          },
        ),
      );
      if (queryResult.hasException) {
        return null;
      } else {
        Game game = Game.fromJson(queryResult.data!['game']);
        return game;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Review?> getReview({required String id}) async {
    try {
      QueryResult queryResult = await client.query(
        QueryOptions(
          document: gql(r""" 
        query Review($reviewId: ID!) {
          review(id: $reviewId) {
            id
            rating
            content
            author {
              name
            }
            game {
              title
            }
          }
        }
      """),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            'reviewId': id,
          },
        ),
      );
      if (queryResult.hasException) {
        return null;
      } else {
        Review review = Review.fromJson(queryResult.data!['review']);
        return review;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> createGame({
    required String title,
    required List<String> platforms,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              mutation AddGame(\$game: AddGameInput!) {
                addGame(game: \$game) {
                  id
                  title
                  platform
                }
                
              }
            """),
          variables: {
            "game": {
              "title": title,
              "platform": platforms,
            }
          },
        ),
      );

      if (result.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteGame({
    required String id,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
          mutation DeleteGame(\$deleteGameId: ID!) {
            deleteGame(id: \$deleteGameId) {
              id
              title
            }
          }
            """),
          variables: {
            "deleteGameId": id,
          },
        ),
      );

      if (result.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateGame({
    required String id,
    String? title,
    List<String>? platforms,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
          mutation UpdateGame(\$updateGameId: ID!, \$edits: EditGameInput) {
            updateGame(id: \$updateGameId, edits: \$edits) {
              id
              title
            }
          }
            """),
          variables: {
            "updateGameId": id,
            "edits": {}
              ..addAll(title != null ? {"title": title} : {})
              ..addAll(platforms != null ? {"platform": platforms} : {})
          },
        ),
      );

      if (result.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }
}
