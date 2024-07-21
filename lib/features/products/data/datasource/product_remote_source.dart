import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:tezda/features/products/data/models/product_model.dart';
import 'package:tezda/features/products/domain/usecase/get_products.dart';

abstract interface class ProductRemoteSource {
  Future<ProductList> getProducts();
}

class ProductRemoteSourceImpl implements ProductRemoteSource {
  http.Client client;
  ProductRemoteSourceImpl(this.client);
  @override
  Future<ProductList> getProducts() async {
    final response =
        await client.get(Uri.parse("https://fakestoreapi.com/products"));
    final List decodedResponse = json.decode(response.body);
    final ProductList products =
        decodedResponse.map((item) => ProductModel.fromJson(item)).toList();
    return products;
  }
}
