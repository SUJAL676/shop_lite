import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_lite/features/favorites/bloc/favorites_bloc.dart';
import 'package:shop_lite/features/favorites/data/fav_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final horizontalPadding = size.width * 0.05;
    final verticalSpacing = size.height * 0.015;
    final imageSize = size.width * 0.22;
    final borderRadius = size.width * 0.04;
    final titleFont = size.width * 0.04;
    final priceFont = size.width * 0.038;
    final iconSize = size.width * 0.06;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: Text(
          "Favorites",
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyState(size);
            }

            return ListView.builder(
              padding: EdgeInsets.all(horizontalPadding),
              itemCount: state.items.length,
              itemBuilder: (_, i) {
                final FavoriteItem item = state.items[i];

                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: verticalSpacing),
                    padding: EdgeInsets.all(size.width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
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
                                  fontSize: titleFont,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              SizedBox(height: verticalSpacing * 0.5),

                              Text(
                                "\$${item.price}",
                                style: TextStyle(
                                  fontSize: priceFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<FavoritesBloc>().add(
                              ToggleFavorite(item),
                            );
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: iconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: size.width * 0.2,
            color: Colors.grey,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "No Favorites Yet",
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "Start adding items to your favorites",
            style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
