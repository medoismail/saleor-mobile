import 'product.dart';

class CartLine {
  final String id;
  final int quantity;
  final String variantId;
  final String variantName;
  final String productName;
  final String? thumbnailUrl;
  final Money? price;

  CartLine({
    required this.id,
    required this.quantity,
    required this.variantId,
    required this.variantName,
    required this.productName,
    this.thumbnailUrl,
    this.price,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) {
    final variant = json['variant'];
    final product = variant['product'];
    Money? price;
    if (variant['pricing']?['price']?['gross'] != null) {
      price = Money.fromJson(variant['pricing']['price']['gross']);
    }

    return CartLine(
      id: json['id'] as String,
      quantity: json['quantity'] as int,
      variantId: variant['id'] as String,
      variantName: variant['name'] as String,
      productName: product['name'] as String,
      thumbnailUrl: product['thumbnail']?['url'] as String?,
      price: price,
    );
  }

  double get totalAmount => (price?.amount ?? 0) * quantity;
}

class Checkout {
  final String id;
  final String token;
  final Money? totalPrice;
  final List<CartLine> lines;

  Checkout({
    required this.id,
    required this.token,
    this.totalPrice,
    required this.lines,
  });

  factory Checkout.fromJson(Map<String, dynamic> json) {
    Money? total;
    if (json['totalPrice']?['gross'] != null) {
      total = Money.fromJson(json['totalPrice']['gross']);
    }

    final linesList = json['lines'] as List<dynamic>? ?? [];

    return Checkout(
      id: json['id'] as String,
      token: json['token'] as String,
      totalPrice: total,
      lines: linesList.map((l) => CartLine.fromJson(l)).toList(),
    );
  }

  int get itemCount => lines.fold(0, (sum, line) => sum + line.quantity);
}
