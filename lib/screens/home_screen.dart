import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/constants.dart';
import '../graphql/queries/products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          CartBadge(
            onTap: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(productsQuery),
          variables: const {
            'channel': AppConstants.defaultChannel,
            'first': AppConstants.productsPerPage,
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading && result.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load products',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: refetch,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final edges =
              result.data?['products']?['edges'] as List<dynamic>? ?? [];
          final products =
              edges.map((e) => Product.fromJson(e['node'])).toList();
          final pageInfo = result.data?['products']?['pageInfo'];
          final hasNextPage = pageInfo?['hasNextPage'] as bool? ?? false;

          if (products.isEmpty) {
            return const Center(
              child: Text('No products available'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => refetch!(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Featured Products',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == products.length) {
                          if (hasNextPage) {
                            fetchMore!(
                              FetchMoreOptions(
                                variables: {
                                  'after': pageInfo?['endCursor'],
                                },
                                updateQuery: (prev, fetchMoreResult) {
                                  final newEdges =
                                      fetchMoreResult?['products']['edges']
                                          as List<dynamic>;
                                  final prevEdges =
                                      prev?['products']['edges']
                                          as List<dynamic>;
                                  fetchMoreResult?['products']['edges'] = [
                                    ...prevEdges,
                                    ...newEdges,
                                  ];
                                  return fetchMoreResult;
                                },
                              ),
                            );
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return null;
                        }

                        return ProductCard(
                          product: products[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product',
                              arguments: products[index],
                            );
                          },
                        );
                      },
                      childCount: products.length + (hasNextPage ? 1 : 0),
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ),
          );
        },
      ),
    );
  }
}
