import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/constants.dart';
import '../graphql/mutations/checkout.dart';
import '../models/cart.dart';

class CartService extends ChangeNotifier {
  Checkout? _checkout;
  bool _isLoading = false;
  String? _error;

  Checkout? get checkout => _checkout;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _checkout?.itemCount ?? 0;
  List<CartLine> get lines => _checkout?.lines ?? [];

  Future<void> createCheckout(
    GraphQLClient client, {
    required String variantId,
    int quantity = 1,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(checkoutCreateMutation),
          variables: {
            'channel': AppConstants.defaultChannel,
            'lines': [
              {'variantId': variantId, 'quantity': quantity},
            ],
          },
        ),
      );

      if (result.hasException) {
        _error = result.exception.toString();
        _isLoading = false;
        notifyListeners();
        return;
      }

      final data = result.data?['checkoutCreate'];
      final errors = data?['errors'] as List<dynamic>?;

      if (errors != null && errors.isNotEmpty) {
        _error = errors.first['message'] as String;
      } else if (data?['checkout'] != null) {
        _checkout = Checkout.fromJson(data['checkout']);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(
    GraphQLClient client, {
    required String variantId,
    int quantity = 1,
  }) async {
    if (_checkout == null) {
      await createCheckout(client, variantId: variantId, quantity: quantity);
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(checkoutLinesAddMutation),
          variables: {
            'id': _checkout!.id,
            'lines': [
              {'variantId': variantId, 'quantity': quantity},
            ],
          },
        ),
      );

      if (result.hasException) {
        _error = result.exception.toString();
        _isLoading = false;
        notifyListeners();
        return;
      }

      final data = result.data?['checkoutLinesAdd'];
      final errors = data?['errors'] as List<dynamic>?;

      if (errors != null && errors.isNotEmpty) {
        _error = errors.first['message'] as String;
      } else if (data?['checkout'] != null) {
        _checkout = Checkout.fromJson(data['checkout']);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeLine(GraphQLClient client, String lineId) async {
    if (_checkout == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(checkoutLineDeleteMutation),
          variables: {
            'id': _checkout!.id,
            'lineId': lineId,
          },
        ),
      );

      final data = result.data?['checkoutLineDelete'];
      if (data?['checkout'] != null) {
        _checkout = Checkout.fromJson(data['checkout']);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> completeCheckout(GraphQLClient client) async {
    if (_checkout == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(checkoutCompleteMutation),
          variables: {'id': _checkout!.id},
        ),
      );

      final data = result.data?['checkoutComplete'];
      final errors = data?['errors'] as List<dynamic>?;

      if (errors != null && errors.isNotEmpty) {
        _error = errors.first['message'] as String;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _checkout = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearCart() {
    _checkout = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
