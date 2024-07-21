import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezda/core/shared/usecase.dart';
import 'package:tezda/features/products/domain/entity/product.dart';
import 'package:tezda/features/products/domain/usecase/get_favorite_products.dart';
import 'package:tezda/features/products/domain/usecase/set_favorite_products.dart';

part 'favorite_products_event.dart';
part 'favorite_products_state.dart';

class FavoriteProductsBloc
    extends Bloc<FavoriteProductsEvent, FavoriteProductsState> {
  final GetFavoriteProducts getFavoriteProducts;
  final SetFavoriteProducts setFavoriteProducts;

  List<int> favoriteProductIds = [];
  List<Product> favoriteProducts = [];

  FavoriteProductsBloc({
    required this.getFavoriteProducts,
    required this.setFavoriteProducts,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  void _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoriteProductsState> emit) async {
    emit(FavoritesLoading());
    final res = await getFavoriteProducts(NoParams());
    res.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) {
        favoriteProducts = favorites;
        favoriteProductIds = favorites.map((product) => product.id).toList();
        emit(FavoritesLoadSuccess(favorites));
      },
    );
  }

  void _onAddFavorite(
      AddFavoriteEvent event, Emitter<FavoriteProductsState> emit) async {
    if (!favoriteProductIds.contains(event.product.id)) {
      favoriteProductIds.add(event.product.id);
      favoriteProducts.add(event.product);
      final res = await setFavoriteProducts(
          FavoriteProductIdParams(favoriteProductIds));
      res.fold((l) => FavoritesError(l.message), (_) {
        emit(FavoritesLoadSuccess(favoriteProducts));
      });
    }
  }

  void _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<FavoriteProductsState> emit) async {
    if (favoriteProductIds.contains(event.product.id)) {
      favoriteProductIds.remove(event.product.id);
      favoriteProducts.removeWhere((p) => event.product.id == p.id);
      final res = await setFavoriteProducts(
          FavoriteProductIdParams(favoriteProductIds));
      res.fold((l) => FavoritesError(l.message), (_) {
        emit(FavoritesLoadSuccess(favoriteProducts));
      });
    }
  }
}
