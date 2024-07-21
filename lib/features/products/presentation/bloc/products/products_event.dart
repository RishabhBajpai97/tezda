part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

final class GetProductsEvent extends ProductsEvent {}
