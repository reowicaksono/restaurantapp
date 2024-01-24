part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent {
  final Restaurant restaurant;

  AddFavoriteEvent({required this.restaurant});
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String restaurantId;

  RemoveFavoriteEvent({required this.restaurantId});
}
