import 'package:fpdart/fpdart.dart';
import 'package:tezda/core/error/failure.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/products/domain/repository/product_repository.dart';

class SetFavoriteProducts
    implements UseCase<void, FavoriteProductIdParams> {
  final ProductRepository productRepository;
  SetFavoriteProducts(this.productRepository);
  @override
  Future<Either<Failure, void>> call(FavoriteProductIdParams params) async {
    return await productRepository.setFavoriteProducts(params.ids);
  }
}

class FavoriteProductIdParams {
  final List<int> ids;
  FavoriteProductIdParams(this.ids);
}
