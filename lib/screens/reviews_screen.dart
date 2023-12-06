import 'package:flutter/material.dart';
import 'package:graphql_demo/data/data_source/remote/query.dart';
import 'package:graphql_demo/domain/entities/review.dart';
import 'package:graphql_demo/widgets/app_bar.dart';
import 'package:graphql_demo/widgets/item_listtile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ReviewsScreen extends StatefulWidget {
  static const String routeName = 'reviews';
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final ScrollController scrollController = ScrollController();
  List<Review> reviews = [];

  bool get isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }

  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainAppBar(title: 'Reviews')),
      body: Query(
        options: QueryOptions(
          document: gql(GrapqhQuery.getReviewPagination),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: {
            'page': page,
          },
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          reviews = <Review>[];

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }
          if (result.isLoading && reviews.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 1.5,
              ),
            );
          }
          for (var item in result.data!['reviewsPagination']) {
            if (item is Map<String, dynamic>) {
              reviews.add(Review.fromJson(item));
            } else {
              reviews.add(item);
            }
          }
          return RefreshIndicator(
            onRefresh: refetch!,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        thickness: 1,
                      );
                    },
                    itemCount: reviews.length,
                    itemBuilder: (_, index) {
                      final review = reviews[index];
                      return ItemListTile(
                        icon: Icons.rate_review_rounded,
                        title: review.content ?? "Review title",
                        editFunction: () {},
                        deleteFunction: () {},
                        callback: () {},
                        subtitle:
                            '${review.author?.name}\n${review.game?.title}',
                      );
                    },
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      fetchMore!(
                        FetchMoreOptions.partial(
                          variables: {"page": ++page},
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            return {
                              '__typename': 'Query',
                              'reviewsPagination': [
                                ...previousResultData!['reviewsPagination'],
                                ...fetchMoreResultData!['reviewsPagination']
                              ]
                            };
                          },
                        ),
                      );
                    },
                    child: const Text("Load more"))
              ],
            ),
          );
        },
      ),
    );
  }
}
