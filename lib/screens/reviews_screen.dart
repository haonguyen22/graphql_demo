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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: MainAppBar(title: 'Reviews')),
        body: Query(
          options: QueryOptions(
              document: gql(GrapqhQuery.queryAllReviews),
              fetchPolicy: FetchPolicy.cacheFirst),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Center(child: Text(result.exception.toString()));
            }
            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 1.5,
                ),
              );
            }
            final List<Review> reviews = [];
            for (var item in result.data!['reviews']) {
              reviews.add(Review.fromJson(item));
            }
            return Column(children: [
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
                      subtitle: review.author?.name,
                    );
                  },
                ),
              ),
            ]);
          },
        ));
  }
}
