import 'package:hive/hive.dart';
import 'package:shop_lite/features/catalog/data/product_apiservice.dart';
import 'package:shop_lite/features/catalog/data/product_model.dart';

class ProductRepository {
  final ProductApiService api;
  final box = Hive.box('products_box');

  ProductRepository(this.api);

  Future<List<ProductModel>> getProducts(int limit, int skip) async {
    try {
      final data = await api.getProducts(limit, skip);
      if (skip == 0) {
        await box.put('products', data);
        await box.put('timestamp', DateTime.now().toString());
      }

      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      final cached = box.get('products');

      if (cached != null) {
        return (cached as List).map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception("No data available");
      }
    }
  }

  Future<List<String>> getCategories() async {
    final data = await api.getCategories();
    return List<String>.from(data);
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final data = await api.getProductsByCategory(category);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final data = await api.searchProducts(query);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
