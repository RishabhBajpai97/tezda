part of 'favorite_products_bloc.dart';

@immutable
sealed class FavoriteProductsState {}

final class FavoritesInitial extends FavoriteProductsState {}

final class FavoritesLoading extends FavoriteProductsState {}

final class FavoritesError extends FavoriteProductsState {
  final String message;
  FavoritesError(this.message);
}

final class FavoritesLoadSuccess extends FavoriteProductsState {
  final List<Product> favoriteProducts;
  FavoritesLoadSuccess(this.favoriteProducts);
}
