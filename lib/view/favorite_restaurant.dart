import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/domain/bloc/favorites/favorite_bloc.dart';
import 'package:restaurant_app/domain/models/restaurant_models_api.dart';
import 'package:restaurant_app/utils/app_constants.dart';

class RestaurantFavorite extends StatelessWidget {
  const RestaurantFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.amber,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          print("state : ${state}");
          if (state is FavoriteLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            return _buildFavoritesList(state.favorites, context);
          } else {
            return Center(child: Text('No Favorites'));
          }
        },
      ),
    );
  }

  Widget _buildFavoritesList(List<Restaurant> favorites, BuildContext context) {
    if (favorites.isEmpty) {
      return Center(
        child: Text("No favorites"),
      );
    } else {
      return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final restaurant = favorites[index];

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text('${restaurant.name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 18),
                    Text("${restaurant.city}"),
                    const SizedBox(width: 8),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text('${restaurant.rating ?? 0.0}'),
                  ],
                ),
              ],
            ),
            leading: Hero(
              tag: 'restaurant_image_${restaurant.pictureId}',
              child: Image.network(
                URL_IMAGE + "${restaurant.pictureId}",
                width: 100,
                errorBuilder: (ctx, error, _) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                _removeFavorite(context, restaurant.id!);
              },
            ),
          );
        },
      );
    }
  }

  void _removeFavorite(BuildContext context, String restaurantId) {
    context.read<FavoriteBloc>().add(
          RemoveFavoriteEvent(
            restaurantId: restaurantId,
          ),
        );
  }
}
