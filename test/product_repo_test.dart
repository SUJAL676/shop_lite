import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shop_lite/features/catalog/data/product_apiservice.dart';
import 'package:shop_lite/features/catalog/data/product_model.dart';
import 'package:shop_lite/features/catalog/data/product_respository.dart';

class FakeProductApiService extends ProductApiService {
  FakeProductApiService() : super(Dio());

  Future<List<ProductModel>> fetchProducts(int limit, int skip) async {
    print("✅ FAKE API CALLED");

    return [
      ProductModel(
        id: 1,
        title: "Test Product",
        price: 100,
        description: "Test Description",
        thumbnail: "test.png",
        rating: 4,
        shippinginfo: "Free Delivery",
      ),
    ];
  }
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp();

    Hive.init(tempDir.path);

    await Hive.openBox('products_box');
    await Hive.openBox('cart_box');
    await Hive.openBox('favorites_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('Product Repository Tests', () {
    late ProductRepository repo;

    setUp(() {
      repo = ProductRepository(FakeProductApiService());
    });

    test('Product list should not be empty', () async {
      final products = await repo.getProducts(20, 0);

      expect(products.isNotEmpty, true);
    });

    test('products should have valid fields', () async {
      final products = await repo.getProducts(10, 0);

      final product = products.first;

      expect(product.title.isNotEmpty, true);
      expect(product.price > 0, true);
    });

    test('products length should match fake data', () async {
      final products = await repo.getProducts(1, 0);

      expect(products.length, 1);
    });
  });
}
