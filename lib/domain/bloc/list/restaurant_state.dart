part of 'restaurant__bloc.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final ApiRestaurantModel apiRestaurantModel;
  const RestaurantLoaded(this.apiRestaurantModel);
}

class RestaurantError extends RestaurantState {
  final String? message;
  const RestaurantError(this.message);
}
