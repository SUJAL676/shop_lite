import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:shop_lite/features/catalog/bloc/product_bloc.dart';
import 'package:shop_lite/features/catalog/data/product_apiservice.dart';
import 'package:shop_lite/features/catalog/data/product_model.dart';
import 'package:shop_lite/features/catalog/data/product_respository.dart';
import 'package:shop_lite/features/catalog/screens/catalog_screen.dart';

/// ✅ Fake Repository (NO API calls)
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
    return ["beauty"];
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    return [];
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    return [];
  }

  @override
  // TODO: implement api
  ProductApiService get api => throw UnimplementedError();

  @override
  // TODO: implement box
  Box<dynamic> get box => throw UnimplementedError();
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    /// ✅ Setup Hive (fix crash)
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

  testWidgets('Products screen shows data', (WidgetTester tester) async {
    final bloc = ProductsBloc(FakeProductRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => bloc..add(FetchProducts()),
          child: CatalogScreen(username: "sujal", userphoto: ""),
        ),
      ),
    );

    /// wait for async operations
    await tester.pumpAndSettle();

    /// ✅ Verify product appears
    expect(find.text("Test Product"), findsOneWidget);
  });

  testWidgets('Search with empty query resets products', (tester) async {
    final bloc = ProductsBloc(FakeProductRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => bloc..add(SearchProducts("")),
          child: CatalogScreen(username: "sujal", userphoto: ""),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Test Product"), findsOneWidget);
  });
}
