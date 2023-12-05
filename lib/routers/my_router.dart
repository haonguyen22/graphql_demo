import 'package:go_router/go_router.dart';
import 'package:graphql_demo/screens/authors_screen.dart';
import 'package:graphql_demo/screens/game_details_screen.dart';
import 'package:graphql_demo/screens/game_screen.dart';
import 'package:graphql_demo/screens/home_screen.dart';
import 'package:graphql_demo/screens/reviews_screen.dart';
import 'package:graphql_demo/utils/helpers.dart';

class MyRouter {
  static final router = GoRouter(
    // set the router to listen for changes to the loginState
    // refreshListenable: loginState,
    // Show debugging logs.
    debugLogDiagnostics: true,
    initialLocation: '/',
    // Routes
    routes: [
      GoRoute(
        name: HomeScreen.routeName,
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: GamesScreen.routeName,
        path: '/games',
        pageBuilder: (context, state) {
          return Helpers.buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const GamesScreen(),
          );
        },
      ),
      GoRoute(
        name: AuthorsScreen.routeName,
        path: '/authors',
        pageBuilder: (context, state) {
          return Helpers.buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const AuthorsScreen(),
          );
        },
      ),
      GoRoute(
        name: ReviewsScreen.routeName,
        path: '/reviews',
        pageBuilder: (context, state) {
          return Helpers.buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const ReviewsScreen(),
          );
        },
      ),
      GoRoute(
        name: GameDetailsScreen.routeName,
        path: '/game/:id',
        pageBuilder: (context, state) {
          return Helpers.buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: GameDetailsScreen(id: state.pathParameters['id']!),
          );
        },
      ),
    ],
  );
}
