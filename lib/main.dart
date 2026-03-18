import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_lite/core/storage/secure_storage.dart';
import 'package:shop_lite/features/auth/bloc/auth_bloc.dart';
import 'package:shop_lite/features/auth/data/auth_api_service.dart';
import 'package:shop_lite/features/cart/bloc/cart_bloc.dart';
import 'package:shop_lite/features/catalog/bloc/product_bloc.dart';
import 'package:shop_lite/features/catalog/data/product_apiservice.dart';
import 'package:shop_lite/features/catalog/data/product_respository.dart';
import 'package:shop_lite/features/favorites/bloc/favorites_bloc.dart';
import 'package:shop_lite/features/splash/bloc/splash_bloc.dart';
import 'package:shop_lite/features/splash/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('products_box');
  await Hive.openBox('cart_box');
  await Hive.openBox('favorites_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final authapi = AuthApiService(dio);
    final productapi = ProductApiService(dio);
    final productrepo = ProductRepository(productapi);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authapi, SecureStorage())),
        BlocProvider(create: (context) => SplashBloc(SecureStorage())),
        BlocProvider(
          create: (_) => ProductsBloc(productrepo)..add(FetchProducts()),
        ),
        BlocProvider(create: (_) => CartBloc()..add(LoadCart())),
        BlocProvider(create: (_) => FavoritesBloc()..add(LoadFavorites())),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: SplashScreen(),
      ),
    );
  }
}
