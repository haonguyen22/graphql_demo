import 'package:flutter/material.dart';
import 'package:graphql_demo/config/graphql_config.dart';
import 'package:graphql_demo/routers/my_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLConfig().clientToQuery(),
  );
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp.router(
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(95, 111, 82, 1),
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(95, 111, 82, 1),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: MyRouter.router,
      ),
    );
  }
}
