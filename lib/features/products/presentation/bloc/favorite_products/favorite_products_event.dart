part of 'favorite_products_bloc.dart';

@immutable
sealed class FavoriteProductsEvent {}

final class LoadFavoritesEvent extends FavoriteProductsEvent {}

final class AddFavoriteEvent extends FavoriteProductsEvent {
  final Product product;
  AddFavoriteEvent(this.product);
}

final class RemoveFavoriteEvent extends FavoriteProductsEvent {
  final Product product;
  RemoveFavoriteEvent(this.product);
}
