import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartBadge extends StatelessWidget {
  final VoidCallback onTap;

  const CartBadge({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cart, child) {
        return IconButton(
          onPressed: onTap,
          icon: Badge(
            isLabelVisible: cart.itemCount > 0,
            label: Text(
              cart.itemCount.toString(),
              style: const TextStyle(fontSize: 10),
            ),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        );
      },
    );
  }
}
