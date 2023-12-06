import 'package:flutter/material.dart';
import 'package:graphql_demo/domain/entities/review.dart';

class ReviewCard extends StatelessWidget {
  final Review? review;
  const ReviewCard({
    super.key,
    this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                review?.author?.name ?? "Unknown",
                style: const TextStyle(
                  fontSize: 18, // Increased text size to 18
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow[700],
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                'Rating: ${review?.rating ?? "N/A"}',
                style: const TextStyle(
                  fontSize: 16, // Increased text size to 16
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review?.content ?? "",
            style: const TextStyle(
              fontSize: 16, // Increased text size to 16
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
