import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/products/domain/usecase/get_products.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts _getProducts;
  ProductsBloc({required GetProducts getProducts})
      : _getProducts = getProducts,
        super(ProductsInitial()) {
    on<ProductsEvent>((_, emit) {
      emit(ProductsLoading());
    });
    on<GetProductsEvent>(
      (event, emit) async {
        final res = await _getProducts(NoParams());
        res.fold((l) => ProductsFailure(l.message), (products) => emit(ProductsSuccess(products)));
      },
    );
  }
}
