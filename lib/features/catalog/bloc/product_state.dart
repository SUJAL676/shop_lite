part of 'product_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  final List<String> categories;

  ProductsLoaded(this.products, this.categories);
}

final class ProductsError extends ProductsState {}

final class ProductOffline extends ProductsState {}
