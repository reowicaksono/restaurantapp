part of 'restaurant_detail_bloc.dart';

sealed class RestaurantDetailState extends Equatable {
  const RestaurantDetailState();

  @override
  List<Object> get props => [];
}

final class RestaurantDetailInitial extends RestaurantDetailState {}

class RestaurantDetailLoaded extends RestaurantDetailState {
  final ApiDetailRestaurantModel apiRestaurantDetailModel;

  RestaurantDetailLoaded(this.apiRestaurantDetailModel);
  @override
  List<Object> get props => [apiRestaurantDetailModel];
}

class RestaurantDetailError extends RestaurantDetailState {
  final String? message;
  const RestaurantDetailError(this.message);
}

class RestaurantDetailLoading extends RestaurantDetailState {}
