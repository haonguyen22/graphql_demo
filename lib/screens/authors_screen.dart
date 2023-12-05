import 'package:flutter/material.dart';
import 'package:graphql_demo/data/data_source/remote/graphql_service.dart';
import 'package:graphql_demo/domain/entities/author.dart';
import 'package:graphql_demo/widgets/app_bar.dart';
import 'package:graphql_demo/widgets/item_listtile.dart';

class AuthorsScreen extends StatefulWidget {
  static const String routeName = 'authors';
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  final GraphQLService _graphQLService = GraphQLService();
  List<Author>? _authors;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    _authors = await _graphQLService.getAuthors();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainAppBar(title: 'Games')),
      body: _authors == null
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
                  itemCount: _authors?.length ?? 0,
                  itemBuilder: (_, index) {
                    final author = _authors?[index];
                    return ItemListTile(
                      icon: Icons.person_rounded,
                      title: author?.name ?? "Author name",
                      editFunction: () {},
                      deleteFunction: () {},
                      subtitle: author?.id,
                      callback: () {},
                    );
                  },
                ),
              ),
            ]),
    );
  }
}
