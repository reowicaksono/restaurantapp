part of 'restaurant_detail_bloc.dart';

abstract class RestaurantDetailEvent extends Equatable {
  final String restaurantId;
  const RestaurantDetailEvent(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

class GetRestaurantDetail extends RestaurantDetailEvent {
  GetRestaurantDetail(super.restaurantId);
}

class AddReviewEvent extends RestaurantDetailEvent {
  final String restaurantId;
  final String name;
  final String review;

  AddReviewEvent({
    required this.restaurantId,
    required this.name,
    required this.review,
  }) : super(restaurantId);

  @override
  List<Object> get props => [restaurantId, name, review];
}
