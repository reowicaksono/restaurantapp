// favorite_state.dart

part of 'favorite_bloc.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Restaurant> favorites;

  FavoriteLoaded(this.favorites);
}
