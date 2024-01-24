part of 'restaurant__bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class GetRestaurantList extends RestaurantEvent {}
