import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_lite/core/widget/animated_toast.dart';
import 'package:shop_lite/features/cart/bloc/cart_bloc.dart';
import 'package:shop_lite/features/cart/data/cart_model.dart';
import 'package:shop_lite/features/favorites/bloc/favorites_bloc.dart';
import 'package:shop_lite/features/favorites/data/fav_model.dart';
import '../data/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: _buildBottomBar(size),

      appBar: AppBar(backgroundColor: Color(0xFFF5F5F5)),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildImageSection(size),
                    _buildDetailsSection(size),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Container(
        height: size.height * 0.35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.width * 0.05),
          child: Hero(
            tag: "product_${widget.product.id}",
            child: Image.network(
              widget.product.thumbnail,
              fit: BoxFit.cover,
              width: double.infinity,
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
      ),
    );
  }

  Widget _buildDetailsSection(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.01),
          Text(
            widget.product.title,
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: size.height * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "\$${widget.product.price}",
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < widget.product.rating.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Color(0xFFF4B266),
                    size: size.width * 0.065,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.02),
            ],
          ),

          SizedBox(height: size.height * 0.015),

          SizedBox(height: size.height * 0.02),
          Text(
            "Description",
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: size.height * 0.01),

          Text(
            widget.product.description,
            style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey),
          ),

          SizedBox(height: size.height * 0.015),

          SizedBox(height: size.height * 0.1),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Size size) {
    return Container(
      padding: EdgeInsets.all(
        size.width * 0.04,
      ).copyWith(bottom: size.width * 0.1),
      decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
      child: Row(
        children: [
          _buildFavoriteButton(size),
          SizedBox(width: size.width * 0.04),
          Expanded(child: _buildCartButton(size)),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(Size size) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        bool isFav = false;

        if (state is FavoritesLoaded) {
          isFav = state.items.any((item) => item.id == widget.product.id);
        }

        return GestureDetector(
          onTap: () {
            final item = FavoriteItem(
              id: widget.product.id,
              title: widget.product.title,
              image: widget.product.thumbnail,
              price: widget.product.price,
            );

            final wasFav = isFav;

            context.read<FavoritesBloc>().add(ToggleFavorite(item));

            showAnimatedToast(
              context,
              message: wasFav ? "Removed from favorites" : "Added to favorites",
              color: wasFav ? Colors.red : Colors.green,
            );
          },
          child: Container(
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width * 0.03),
              border: Border.all(color: Colors.grey),
            ),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.black,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartButton(Size size) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        bool isInCart = false;

        if (state is CartLoaded) {
          isInCart = state.items.any((item) => item.id == widget.product.id);
        }

        return ElevatedButton(
          onPressed: () {
            final wasInCart = isInCart;

            if (wasInCart) {
              context.read<CartBloc>().add(RemoveFromCart(widget.product.id));
            } else {
              final item = CartItem(
                id: widget.product.id,
                title: widget.product.title,
                price: widget.product.price,
                image: widget.product.thumbnail,
              );

              context.read<CartBloc>().add(AddToCart(item));
            }

            showAnimatedToast(
              context,
              message: wasInCart ? "Removed from cart" : "Added to cart",
              color: wasInCart ? Colors.red : Colors.green,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isInCart ? Colors.black : const Color(0xFFF4B266),
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isInCart ? Icons.delete_outline : Icons.shopping_cart_outlined,
                color: isInCart ? Colors.white : Colors.black,
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                isInCart ? "Remove from Cart" : "Add to Cart",
                style: TextStyle(color: isInCart ? Colors.white : Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
