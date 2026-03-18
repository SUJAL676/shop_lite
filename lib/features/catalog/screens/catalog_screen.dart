import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_lite/features/cart/screens/cart_screen.dart';
import 'package:shop_lite/features/catalog/bloc/product_bloc.dart';
import 'package:shop_lite/features/catalog/data/product_model.dart';
import 'package:shop_lite/features/catalog/screens/product_details_screen.dart';
import 'package:shop_lite/features/favorites/screens/fav_screen.dart';

class CatalogScreen extends StatefulWidget {
  final String username;
  final String userphoto;

  const CatalogScreen({
    super.key,
    required this.username,
    required this.userphoto,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final scrollController = ScrollController();
  TextEditingController controller = TextEditingController();

  bool isOffline = false;

  @override
  void initState() {
    listenToConnectivity();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<ProductsBloc>().add(LoadMoreProducts());
      }
    });

    super.initState();
  }

  void listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      final hasConnection =
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);

      final offline = !hasConnection;

      if (mounted) {
        setState(() {
          isOffline = offline;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return Center(
                child: SizedBox(
                  height: size.width * 0.4,
                  child: LottieBuilder.asset(
                    "assets/animation_file/loading_wave.json",
                  ),
                ),
              );
            }

            if (state is ProductsLoaded) {
              return Column(
                children: [
                  if (isOffline)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      color: Colors.red,
                      padding: EdgeInsets.all(size.width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            color: Colors.white,
                            size: size.width * 0.04,
                          ),
                          SizedBox(width: size.width * 0.02),
                          Text(
                            "You're offline. Showing cached data",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(child: _buildGreeting(size)),

                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SearchBarDelegate(controller),
                        ),

                        SliverToBoxAdapter(
                          child: _buildCategories(state.categories, size),
                        ),

                        SliverList(
                          delegate: SliverChildBuilderDelegate((_, i) {
                            final p = state.products[i];
                            return _productCard(p, size);
                          }, childCount: state.products.length),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(child: Text("Error"));
          },
        ),
      ),
    );
  }

  Widget _buildGreeting(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
      ).copyWith(top: size.height * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello ${widget.username}",
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Find your perfect style",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: size.width * 0.035,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              _iconButton(
                size,
                icon: Icons.favorite_border,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              ),

              SizedBox(width: size.width * 0.04),

              _iconButton(
                size,
                icon: Icons.shopping_bag,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    Size size, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
        child: Icon(icon, size: size.width * 0.06),
      ),
    );
  }

  Widget _buildCategories(List<String> categories, Size size) {
    final bloc = context.read<ProductsBloc>();

    return SizedBox(
      height: size.height * 0.07,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final category = categories[i];
          final isSelected = bloc.selectedCategory == category;

          return GestureDetector(
            onTap: () {
              controller.text = "";
              bloc.add(FilterByCategory(category));
            },
            child: Container(
              margin: EdgeInsets.all(size.width * 0.02),
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.012,
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF4B266) : Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
              ),
              child: Text(
                category.toUpperCase(),
                style: TextStyle(fontSize: size.width * 0.035),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productCard(ProductModel p, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.01,
        ),
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.04),
        ),
        child: Row(
          children: [
            Hero(
              tag: "product_${p.id}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.width * 0.03),
                child: Image.network(
                  p.thumbnail,
                  height: size.width * 0.25,
                  width: size.width * 0.25,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: size.width * 0.04),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: size.height * 0.008),

                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < p.rating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFF4B266),
                        size: size.width * 0.04,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.008),

                  Text(
                    "\$${p.price}",
                    style: TextStyle(fontSize: size.width * 0.04),
                  ),

                  SizedBox(height: size.height * 0.008),

                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: size.width * 0.04,
                        color: const Color(0xFFF4B266),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Text(
                          p.shippinginfo,
                          style: TextStyle(fontSize: size.width * 0.032),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  SearchBarDelegate(this.controller);

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search here",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller.clear();
                          context.read<ProductsBloc>().add(SearchProducts(""));
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GestureDetector(
              onTap: () {
                if (controller.text.isNotEmpty) {
                  context.read<ProductsBloc>().add(
                    SearchProducts(controller.text),
                  );
                }
              },
              child: Icon(Icons.manage_search_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_) => false;
}
