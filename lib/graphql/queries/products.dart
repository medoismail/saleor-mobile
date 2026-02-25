const String productsQuery = r'''
  query Products($channel: String!, $first: Int!, $after: String, $sortBy: ProductOrder, $filter: ProductFilterInput) {
    products(channel: $channel, first: $first, after: $after, sortBy: $sortBy, filter: $filter) {
      edges {
        node {
          id
          name
          slug
          description
          thumbnail {
            url
            alt
          }
          pricing {
            priceRange {
              start {
                gross {
                  amount
                  currency
                }
              }
              stop {
                gross {
                  amount
                  currency
                }
              }
            }
          }
          category {
            name
          }
        }
        cursor
      }
      pageInfo {
        hasNextPage
        endCursor
      }
      totalCount
    }
  }
''';

const String productDetailQuery = r'''
  query ProductDetail($slug: String!, $channel: String!) {
    product(slug: $slug, channel: $channel) {
      id
      name
      slug
      description
      seoDescription
      thumbnail {
        url
        alt
      }
      media {
        url
        alt
        type
      }
      pricing {
        priceRange {
          start {
            gross {
              amount
              currency
            }
          }
        }
      }
      category {
        name
        slug
      }
      variants {
        id
        name
        sku
        pricing {
          price {
            gross {
              amount
              currency
            }
          }
        }
        quantityAvailable
      }
      isAvailable
    }
  }
''';

const String categoriesQuery = r'''
  query Categories($first: Int!) {
    categories(first: $first) {
      edges {
        node {
          id
          name
          slug
          backgroundImage {
            url
            alt
          }
          description
        }
      }
    }
  }
''';

const String searchProductsQuery = r'''
  query SearchProducts($channel: String!, $first: Int!, $search: String!) {
    products(channel: $channel, first: $first, filter: { search: $search }) {
      edges {
        node {
          id
          name
          slug
          thumbnail {
            url
            alt
          }
          pricing {
            priceRange {
              start {
                gross {
                  amount
                  currency
                }
              }
            }
          }
        }
      }
    }
  }
''';
