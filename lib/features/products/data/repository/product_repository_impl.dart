
import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/error/exception.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/features/products/data/datasource/local_data_source.dart';
import 'package:tezda/features/products/data/datasource/product_remote_source.dart';
import 'package:tezda/features/products/domain/repository/product_repository.dart';
import 'package:tezda/features/products/domain/usecase/get_products.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteSource productRemoteSource;
  final LocalDataSource localDataSource;
  ProductRepositoryImpl(this.productRemoteSource, this.localDataSource);
  @override
  Future<Either<Failure, ProductList>> getProducts() async {
    try {
      final response = await productRemoteSource.getProducts();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProductList>> getFavoriteProducts() async {
    try {
      final favoriteIds = await localDataSource.getFavoriteProductIds();
      final allProducts = await productRemoteSource.getProducts();
      final favoriteProducts = allProducts
          .where((product) => favoriteIds.contains(product.id))
          .toList();
      return right(favoriteProducts);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> setFavoriteProducts(List<int> ids) async {
    try {
      await localDataSource.cacheFavoriteProductIds(ids);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
