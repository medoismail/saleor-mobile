import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'config/graphql_client.dart';
import 'config/constants.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  runApp(const SaleorApp());
}

class SaleorApp extends StatelessWidget {
  const SaleorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = GraphQLConfig.initClient();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1C1C1C),
              primary: const Color(0xFF1C1C1C),
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                );
              case '/product':
                final product = settings.arguments as Product;
                return MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                );
              case '/cart':
                return MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                );
              case '/checkout':
                return MaterialPageRoute(
                  builder: (_) => const CheckoutScreen(),
                );
              case '/login':
                return MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                );
              case '/register':
                return MaterialPageRoute(
                  builder: (_) => const RegisterScreen(),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                );
            }
          },
        ),
      ),
    );
  }
}
