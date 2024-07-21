
import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/products/domain/entity/product.dart';
import 'package:tezda/features/products/domain/repository/product_repository.dart';

class GetProducts implements UseCase<ProductList, NoParams> {
  final ProductRepository productRepository;
  GetProducts(this.productRepository);
  @override
  Future<Either<Failure, ProductList>> call(NoParams params) async {
    return await productRepository.getProducts();
  }
}

typedef ProductList = List<Product>;
