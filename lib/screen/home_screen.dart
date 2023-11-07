import 'package:flutter/material.dart';
import 'package:graphql_demo/data/data_source/remote/graphql_service.dart';
import 'package:graphql_demo/domain/entities/game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GraphQLService _graphQLService = GraphQLService();
  List<Game>? _games;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    _games = await _graphQLService.getGames();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const Text('Games'),
        Expanded(
          child: ListView.builder(
            itemCount: _games?.length,
            itemBuilder: (_, index) {
              final game = _games?[index];

              return ListTile(
                title: Text(game?.title ?? ''),
                subtitle: Text(game?.platform?[0] ?? ''),
              );
            },
          ),
        ),
      ]),
    );
  }
}
