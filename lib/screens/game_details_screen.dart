import 'package:flutter/material.dart';
import 'package:graphql_demo/domain/entities/game.dart';
import 'package:graphql_demo/widgets/app_bar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GameDetailsScreen extends StatefulWidget {
  static const String routeName = 'game-details';
  final String id;
  const GameDetailsScreen({super.key, required this.id});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
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
          'gameId': widget.id,
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Scaffold(
            body: Center(
              child: Text(
                result.exception.toString(),
              ),
            ),
          );
        }
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 1.5,
            ),
          );
        }
        final Game game = Game.fromJson(result.data!['game']);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: MainAppBar(title: game.title ?? "Game Details"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  game.title ?? "Game title",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Platform',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  game.platform?.join(" - ") ?? 'Platform',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(
                    game.reviews?.length ?? 0,
                    (index) {
                      final review = game.reviews?[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  review?.author?.name ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 18, // Increased text size to 18
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[700],
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Rating: ${review?.rating ?? "N/A"}',
                                  style: const TextStyle(
                                    fontSize: 16, // Increased text size to 16
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review?.content ?? "",
                              style: const TextStyle(
                                fontSize: 16, // Increased text size to 16
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
