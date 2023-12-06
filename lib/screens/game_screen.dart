// Solution 1: using call service normallly to get api

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_demo/data/data_source/remote/graphql_service.dart';
import 'package:graphql_demo/domain/entities/game.dart';
import 'package:graphql_demo/screens/game_details_screen.dart';
import 'package:graphql_demo/widgets/app_bar.dart';
import 'package:graphql_demo/widgets/item_listtile.dart';

class GamesScreen extends StatefulWidget {
  static const String routeName = 'games';
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final GraphQLService _graphQLService = GraphQLService();
  List<Game>? _games;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController platformController = TextEditingController();

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    _games = await _graphQLService.getGames();
    setState(() {});
  }

  void resetField() {
    titleController.text = "";
    platformController.text = "";
  }

  void createGame() async {
    await _graphQLService
        .createGame(
            title: titleController.text,
            platforms: platformController.text.split(","))
        .then((value) {
      load();
      Navigator.of(context).pop();
    });
  }

  void editGame(String? id) async {
    if (id == null) return;
    await _graphQLService
        .updateGame(
            id: id,
            title: titleController.text,
            platforms: platformController.text.split(","))
        .then((value) {
      load();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainAppBar(title: 'Games')),
      body: _games == null
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 1.5,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        thickness: 1,
                      );
                    },
                    itemCount: _games?.length ?? 0,
                    itemBuilder: (_, index) {
                      final game = _games?[index];
                      return ItemListTile(
                        icon: Icons.sports_esports,
                        title: game?.title ?? "Game title",
                        editFunction: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              resetField();

                              titleController.text = game?.title ?? "";
                              platformController.text =
                                  game?.platform?.join(", ") ?? "";

                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Edit game'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Title',
                                            icon: Icon(Icons.title),
                                          ),
                                          controller: titleController,
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Platform',
                                            icon: Icon(Icons.manage_history),
                                          ),
                                          controller: platformController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => editGame(game?.id),
                                    child: const Text("Edit"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        deleteFunction: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Delete game'),
                                content: const Text(
                                    'Are you sure you want to delete this game?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _graphQLService
                                          .deleteGame(id: game?.id ?? "")
                                          .then((value) {
                                        load();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        subtitle: game?.platform?.join(" - "),
                        callback: () {
                          GoRouter.of(context).pushNamed(
                              GameDetailsScreen.routeName,
                              pathParameters: {
                                'id': game?.id ?? "0",
                              });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              resetField();

              return AlertDialog(
                scrollable: true,
                title: const Text('Create new game'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            icon: Icon(Icons.title),
                          ),
                          controller: titleController,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Platform',
                            icon: Icon(Icons.manage_history),
                          ),
                          controller: platformController,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: createGame,
                    child: const Text("Create"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
