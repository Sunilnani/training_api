// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  Products({
    this.filters,
    this.products,
  });

  Filters filters;
  List<Product> products;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    filters: Filters.fromJson(json["filters"]),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filters": filters.toJson(),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Filters {
  Filters({
    this.limit,
    this.page,
    this.totalCount,
  });

  int limit;
  int page;
  int totalCount;

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    limit: json["limit"],
    page: json["page"],
    totalCount: json["total_count"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "page": page,
    "total_count": totalCount,
  };
}

class Product {
  Product({
    this.amount,
    this.description,
    this.image,
    this.name,
    this.productId,
  });

  double amount;
  String description;
  String image;
  String name;
  int productId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    amount: json["amount"],
    description: json["description"],
    image: json["image"],
    name: json["name"],
    productId: json["product_id"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "description": description,
    "image": image,
    "name": name,
    "product_id": productId,
  };
}
