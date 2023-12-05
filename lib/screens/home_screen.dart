import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_demo/screens/authors_screen.dart';
import 'package:graphql_demo/screens/game_screen.dart';
import 'package:graphql_demo/screens/reviews_screen.dart';
import 'package:graphql_demo/widgets/app_bar.dart';
import 'package:graphql_demo/widgets/home_listtile.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainAppBar(title: 'Home'),
      ),
      body: ListView(
        children: ListTile.divideTiles(context: context, tiles: [
          HomeListTile(
            title: 'Games',
            icon: Icons.sports_esports_rounded,
            callback: () {
              GoRouter.of(context).pushNamed(GamesScreen.routeName);
            },
          ),
          HomeListTile(
            title: 'Authors',
            icon: Icons.people_alt_rounded,
            callback: () {
              GoRouter.of(context).pushNamed(AuthorsScreen.routeName);
            },
          ),
          HomeListTile(
            title: 'Reviews',
            icon: Icons.reviews_rounded,
            callback: () {
              GoRouter.of(context).pushNamed(ReviewsScreen.routeName);
            },
          ),
        ]).toList(),
      ),
    );
  }
}
