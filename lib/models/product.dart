class Money {
  final double amount;
  final String currency;

  Money({required this.amount, required this.currency});

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  String get formatted => '\$${amount.toStringAsFixed(2)}';
}

class ProductImage {
  final String url;
  final String? alt;
  final String? type;

  ProductImage({required this.url, this.alt, this.type});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url'] as String,
      alt: json['alt'] as String?,
      type: json['type'] as String?,
    );
  }
}

class ProductVariant {
  final String id;
  final String name;
  final String? sku;
  final Money? price;
  final int? quantityAvailable;

  ProductVariant({
    required this.id,
    required this.name,
    this.sku,
    this.price,
    this.quantityAvailable,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    Money? price;
    final pricing = json['pricing'];
    if (pricing != null && pricing['price'] != null) {
      price = Money.fromJson(pricing['price']['gross']);
    }

    return ProductVariant(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      price: price,
      quantityAvailable: json['quantityAvailable'] as int?,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? thumbnailUrl;
  final String? thumbnailAlt;
  final Money? startPrice;
  final Money? stopPrice;
  final String? categoryName;
  final List<ProductImage> media;
  final List<ProductVariant> variants;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.thumbnailUrl,
    this.thumbnailAlt,
    this.startPrice,
    this.stopPrice,
    this.categoryName,
    this.media = const [],
    this.variants = const [],
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    Money? startPrice;
    Money? stopPrice;
    final pricing = json['pricing'];
    if (pricing != null && pricing['priceRange'] != null) {
      final range = pricing['priceRange'];
      if (range['start'] != null) {
        startPrice = Money.fromJson(range['start']['gross']);
      }
      if (range['stop'] != null) {
        stopPrice = Money.fromJson(range['stop']['gross']);
      }
    }

    final thumbnail = json['thumbnail'];
    final mediaList = json['media'] as List<dynamic>?;
    final variantsList = json['variants'] as List<dynamic>?;

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      thumbnailUrl: thumbnail?['url'] as String?,
      thumbnailAlt: thumbnail?['alt'] as String?,
      startPrice: startPrice,
      stopPrice: stopPrice,
      categoryName: json['category']?['name'] as String?,
      media: mediaList?.map((m) => ProductImage.fromJson(m)).toList() ?? [],
      variants:
          variantsList?.map((v) => ProductVariant.fromJson(v)).toList() ?? [],
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String? backgroundImageUrl;
  final String? description;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.backgroundImageUrl,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      backgroundImageUrl: json['backgroundImage']?['url'] as String?,
      description: json['description'] as String?,
    );
  }
}
