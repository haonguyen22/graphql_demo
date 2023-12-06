class GrapqhQuery {
  static const queryGameById = r""" 
        query Game($gameId: ID!) {
          game(id: $gameId) {
            id
            title
            platform
            reviews {
              rating
              content
              author {
                name
              }
              game {
                title
              }
            }
          }
        }
      """;

  static const addReview = """
    mutation AddReview(\$review: AddReviewInput!) {
      addReview(review: \$review) {
        id
        rating
        content
        author {
          name
        }
        game {
          title
        }
      }
    }
  """;

  static const queryAllReviews = r""" 
    query Reviews {
      reviews {
        id
        rating
        content
        author {
          id
          name
        }
        game {
          id
          title
        }
      }
    }
  """;
}
