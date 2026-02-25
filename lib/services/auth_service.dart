import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/graphql_client.dart';
import '../graphql/mutations/auth.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<bool> login(GraphQLClient client, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(tokenCreateMutation),
          variables: {'email': email, 'password': password},
        ),
      );

      if (result.hasException) {
        _error = result.exception.toString();
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = result.data?['tokenCreate'];
      final errors = data?['errors'] as List<dynamic>?;

      if (errors != null && errors.isNotEmpty) {
        _error = errors.first['message'] as String;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final token = data?['token'] as String?;
      final refreshToken = data?['refreshToken'] as String?;

      if (token != null) {
        await GraphQLConfig.setToken(token);
        if (refreshToken != null) {
          await GraphQLConfig.setRefreshToken(refreshToken);
        }
        _user = User.fromJson(data['user']);
      }

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

  Future<bool> register(
    GraphQLClient client, {
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    required String channel,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(accountRegisterMutation),
          variables: {
            'input': {
              'email': email,
              'password': password,
              'firstName': firstName ?? '',
              'lastName': lastName ?? '',
              'channel': channel,
              'redirectUrl': 'https://store-wlyqn1qu.saleor.cloud/account-confirm/',
            },
          },
        ),
      );

      if (result.hasException) {
        _error = result.exception.toString();
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = result.data?['accountRegister'];
      final errors = data?['errors'] as List<dynamic>?;

      if (errors != null && errors.isNotEmpty) {
        _error = errors.first['message'] as String;
        _isLoading = false;
        notifyListeners();
        return false;
      }

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

  Future<void> logout() async {
    await GraphQLConfig.clearTokens();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
