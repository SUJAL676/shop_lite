part of 'product_bloc.dart';

@immutable
sealed class ProductsEvent {}

final class FetchProducts extends ProductsEvent {}

final class LoadMoreProducts extends ProductsEvent {}

final class FilterByCategory extends ProductsEvent {
  final String category;

  FilterByCategory(this.category);
}

final class SearchProducts extends ProductsEvent {
  final String query;

  SearchProducts(this.query);
}
