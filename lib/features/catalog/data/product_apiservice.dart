import 'package:dio/dio.dart';

class ProductApiService {
  final Dio dio;

  ProductApiService(this.dio);

  Future<List<dynamic>> getProducts(int limit, int skip) async {
    final res = await dio.get(
      'https://dummyjson.com/products',
      queryParameters: {"limit": limit, "skip": skip},
    );

    return res.data['products'];
  }

  Future<List<dynamic>> getCategories() async {
    final res = await dio.get('https://dummyjson.com/products/category-list');

    return res.data;
  }

  Future<List<dynamic>> getProductsByCategory(String category) async {
    final res = await dio.get(
      'https://dummyjson.com/products/category/$category',
    );

    return res.data['products'];
  }

  Future<List<dynamic>> searchProducts(String query) async {
    final res = await dio.get(
      'https://dummyjson.com/products/search',
      queryParameters: {"q": query},
    );

    return res.data['products'];
  }
}
