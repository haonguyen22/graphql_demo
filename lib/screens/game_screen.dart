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
          : Column(children: [
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
                      editFunction: () {},
                      deleteFunction: () {},
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
            ]),
    );
  }
}
