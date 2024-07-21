import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/features/products/domain/usecase/get_products.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, ProductList>> getProducts();
  Future<Either<Failure, ProductList>> getFavoriteProducts();
  Future<Either<Failure, void>> setFavoriteProducts(List<int> ids);
}
