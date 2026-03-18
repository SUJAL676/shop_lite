import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_lite/features/catalog/data/product_model.dart';
import 'package:shop_lite/features/catalog/data/product_respository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository repository;

  int skip = 0;
  final int limit = 20;

  List<ProductModel> products = [];
  List<String> categories = [];

  String selectedCategory = "all";

  String currentQuery = "";

  ProductsBloc(this.repository) : super(ProductsLoading()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductsLoading());

      try {
        final productResult = await repository.getProducts(limit, 0);

        final categoryResult = await repository.getCategories();

        products = productResult;
        categories = ["all", ...categoryResult];

        emit(ProductsLoaded(products, categories));
      } catch (e) {
        final productResult = await repository.getProducts(limit, 0);

        if (productResult.isNotEmpty) {
          products = productResult;
          categories = [];
          emit(ProductsLoaded(products, categories));
        } else {
          emit(ProductsError());
        }
      }
    });

    on<LoadMoreProducts>((event, emit) async {
      if (selectedCategory != "all" || currentQuery.isNotEmpty) return;

      try {
        skip += limit;

        final more = await repository.getProducts(limit, skip);

        products.addAll(more);

        emit(ProductsLoaded(List.from(products), categories));
      } catch (_) {}
    });

    on<FilterByCategory>((event, emit) async {
      emit(ProductsLoading());

      try {
        selectedCategory = event.category;

        if (event.category == "all") {
          products = await repository.getProducts(limit, 0);
        } else {
          products = await repository.getProductsByCategory(event.category);
        }

        emit(ProductsLoaded(products, categories));
      } catch (_) {
        emit(ProductsError());
      }
    });

    on<SearchProducts>((event, emit) async {
      emit(ProductsLoading());

      try {
        currentQuery = event.query;

        if (event.query.isEmpty) {
          // Reset to default
          final result = await repository.getProducts(limit, 0);
          products = result;
        } else {
          final result = await repository.searchProducts(event.query);
          products = result;
        }

        emit(ProductsLoaded(products, categories));
      } catch (_) {
        emit(ProductsError());
      }
    });
  }
}
