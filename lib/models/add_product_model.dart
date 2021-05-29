// To parse this JSON data, do
//
//     final addProducts = addProductsFromJson(jsonString);

import 'dart:convert';

AddProducts addProductsFromJson(String str) => AddProducts.fromJson(json.decode(str));

String addProductsToJson(AddProducts data) => json.encode(data.toJson());

class AddProducts {
  AddProducts({
    this.message,
  });

  String message;

  factory AddProducts.fromJson(Map<String, dynamic> json) => AddProducts(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
