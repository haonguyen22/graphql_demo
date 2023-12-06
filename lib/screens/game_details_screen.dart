/*
Solution 2: using Query and Mutation Widget to get data from server and create new review

*/


import 'package:flutter/material.dart';
import 'package:graphql_demo/data/data_source/remote/graphql_service.dart';
import 'package:graphql_demo/data/data_source/remote/query.dart';
import 'package:graphql_demo/domain/entities/author.dart';
import 'package:graphql_demo/domain/entities/game.dart';
import 'package:graphql_demo/widgets/app_bar.dart';
import 'package:graphql_demo/widgets/game_info.dart';
import 'package:graphql_demo/widgets/review_card.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GameDetailsScreen extends StatefulWidget {
  static const String routeName = 'game-details';
  final String id;
  const GameDetailsScreen({super.key, required this.id});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  List<Author> authors = [];
  GraphQLService graphQLService = GraphQLService();
  TextEditingController ratingCtrl = TextEditingController();
  TextEditingController contentCtrl = TextEditingController();
  Author? selectedAuthor;

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    ratingCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }

  void initLoad() async {
    authors = (await graphQLService.getAuthors()) ?? [];
  }

  void createReview() {}

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(GrapqhQuery.queryGameById),
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
                GameInfoWidget(game: game),
                Column(
                  children: List.generate(
                    game.reviews?.length ?? 0,
                    (index) {
                      final review = game.reviews?[index];
                      return ReviewCard(review: review);
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Review ${game.title}'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            DropdownButtonFormField(
                              items: List.generate(
                                authors.length,
                                (index) => DropdownMenuItem(
                                  value: authors[index],
                                  child: Text(authors[index].name ?? "Unknown"),
                                ),
                              ),
                              hint: const Text('Select Author'),
                              onChanged: (a) {
                                setState(() {
                                  selectedAuthor = authors
                                      .firstWhere((element) => element == a);
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Rating',
                                icon: Icon(Icons.star),
                              ),
                              controller: ratingCtrl,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Content',
                                icon: Icon(Icons.content_paste),
                              ),
                              controller: contentCtrl,
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      Mutation(
                        options: MutationOptions(
                          document: gql(GrapqhQuery.addReview),
                          onCompleted: (data) {
                            Navigator.of(context).pop();
                            refetch!();
                          },
                        ),
                        builder:
                            (RunMutation runMutation, QueryResult? result) {
                          return TextButton(
                            onPressed: () {
                              runMutation(
                                {
                                  'review': {
                                    'rating': int.parse(ratingCtrl.text),
                                    'content': contentCtrl.text,
                                    'author_id': selectedAuthor?.id,
                                    'game_id': game.id,
                                  }
                                },
                              );
                            },
                            child: const Text('Create'),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
