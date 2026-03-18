import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hive/hive.dart';
import 'package:shop_lite/features/catalog/bloc/product_bloc.dart';
import 'package:shop_lite/features/catalog/data/product_apiservice.dart';
import 'package:shop_lite/features/catalog/data/product_model.dart';
import 'package:shop_lite/features/catalog/data/product_respository.dart';

class FakeProductRepository implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts(int limit, int skip) async {
    return [
      ProductModel(
        id: 1,
        title: "Test Product",
        price: 100,
        description: "",
        thumbnail: "",
        rating: 4,
        shippinginfo: "",
      ),
    ];
  }

  @override
  Future<List<String>> getCategories() async {
    return ["beauty", "fragrance"];
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    return [
      ProductModel(
        id: 2,
        title: "Category Product",
        price: 200,
        description: "",
        thumbnail: "",
        rating: 4,
        shippinginfo: "",
      ),
    ];
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    return [
      ProductModel(
        id: 3,
        title: "Search Result",
        price: 150,
        description: "",
        thumbnail: "",
        rating: 4,
        shippinginfo: "",
      ),
    ];
  }

  @override
  ProductApiService get api => throw UnimplementedError();

  @override
  Box<dynamic> get box => throw UnimplementedError();
}

void main() {
  group('ProductsBloc Test', () {
    late ProductsBloc bloc;

    setUp(() {
      bloc = ProductsBloc(FakeProductRepository());
    });

    blocTest<ProductsBloc, ProductsState>(
      'emits [Loading, Loaded] when FetchProducts is added',
      build: () => bloc,
      act: (bloc) => bloc.add(FetchProducts()),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>()
            .having((state) => state.products.length, 'products length', 1)
            .having((state) => state.categories.length, 'categories length', 3),
      ],
    );
  });
}
