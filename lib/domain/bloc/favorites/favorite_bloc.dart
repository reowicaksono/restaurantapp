import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/data/database/database_helper.dart';
import 'package:restaurant_app/domain/models/restaurant_models_api.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final DatabaseHelper databaseHelper;

  FavoriteBloc(this.databaseHelper) : super(FavoriteInitial()) {
    on<AddFavoriteEvent>((event, emit) async {
      await databaseHelper.insertFavorite(event.restaurant);
      emit(await _loadFavorites());
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      await databaseHelper.removeFavorite(event.restaurantId);
      emit(await _loadFavorites());
    });
  }

  Future<FavoriteState> _loadFavorites() async {
    final favorites = await databaseHelper.getFavorite();
    return FavoriteLoaded(favorites);
  }

  Future<bool> isFavorite(String restaurantId) async {
    final favoriteRestaurant =
        await databaseHelper.getFavoriteById(restaurantId);
    return favoriteRestaurant.isNotEmpty;
  }
}
