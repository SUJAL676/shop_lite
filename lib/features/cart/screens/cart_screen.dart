import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_lite/core/widget/animated_toast.dart';
import 'package:shop_lite/features/cart/bloc/cart_bloc.dart';
import 'package:shop_lite/features/cart/screens/order_sucess_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final padding = size.width * 0.05;
    final cardRadius = size.width * 0.04;
    final imageSize = size.width * 0.18;
    final spacing = size.height * 0.015;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyState(size);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(padding),
                    children: [
                      ...state.items.map((item) {
                        return Container(
                          margin: EdgeInsets.only(bottom: spacing),
                          padding: EdgeInsets.all(padding * 0.6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(cardRadius),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  size.width * 0.03,
                                ),
                                child: Image.network(
                                  item.image,
                                  height: imageSize,
                                  width: imageSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: size.width * 0.25,
                                      width: size.width * 0.25,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(width: size.width * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    SizedBox(height: spacing * 0.5),

                                    Text(
                                      "₹${item.price}",
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        color: Color(0xFFF4B266),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: spacing),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  _qtyButton(
                                    context,
                                    icon: Icons.remove,
                                    size: size,
                                    onTap: () {
                                      if (item.quantity > 1) {
                                        context.read<CartBloc>().add(
                                          UpdateQuantity(
                                            item.id,
                                            item.quantity - 1,
                                          ),
                                        );
                                      } else {
                                        context.read<CartBloc>().add(
                                          RemoveFromCart(item.id),
                                        );

                                        showAnimatedToast(
                                          context,
                                          message: "Removed from cart",
                                          color: Colors.red,
                                        );
                                      }
                                    },
                                  ),

                                  SizedBox(width: size.width * 0.03),

                                  Text(
                                    item.quantity.toString(),
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                    ),
                                  ),

                                  SizedBox(width: size.width * 0.03),

                                  _qtyButton(
                                    context,
                                    icon: Icons.add,
                                    size: size,
                                    isPrimary: true,
                                    onTap: () {
                                      context.read<CartBloc>().add(
                                        UpdateQuantity(
                                          item.id,
                                          item.quantity + 1,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      _buildSummary(size, state),
                    ],
                  ),
                ),
                _buildBottomBar(context, size, state),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _qtyButton(
    BuildContext context, {
    required IconData icon,
    required Size size,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size.width * 0.025),
        decoration: BoxDecoration(
          color: isPrimary ? Color(0xFFF4B266) : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: size.width * 0.04,
          color: isPrimary ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildSummary(Size size, CartLoaded state) {
    final spacing = size.height * 0.015;

    final subtotal = state.total;
    final discount = subtotal * 0.03;
    final total = subtotal - discount;

    return Container(
      margin: EdgeInsets.only(top: spacing),
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: spacing),

          _row("Subtotal", subtotal, size),
          _row("Shipping", 0, size, isFree: true),
          _row("Discount", -discount, size),

          Divider(height: spacing * 2),

          _row("Total", total, size, isBold: true),
        ],
      ),
    );
  }

  Widget _row(
    String title,
    double value,
    Size size, {
    bool isFree = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),

          Text(
            isFree ? "Free" : "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: value < 0 ? Color(0xFFF4B266) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, Size size, CartLoaded state) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
      child: ElevatedButton(
        onPressed: () {
          context.read<CartBloc>().add(ClearCart());

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF4B266),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Place Order", style: TextStyle(fontSize: size.width * 0.04)),
            SizedBox(width: size.width * 0.02),
            Icon(Icons.arrow_forward, size: size.width * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag, size: size.width * 0.2, color: Colors.grey),
          SizedBox(height: size.height * 0.02),
          Text(
            "No Item Added",
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "Start adding items to your cart",
            style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
