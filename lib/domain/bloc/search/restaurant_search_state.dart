part of 'restaurant_search_bloc.dart';

sealed class RestaurantSearchState extends Equatable {
  const RestaurantSearchState();

  @override
  List<Object> get props => [];
}

final class RestaurantSearchInitial extends RestaurantSearchState {}

class RestaurantSearchLoading extends RestaurantSearchState {}

class RestaurantSearchResult extends RestaurantSearchState {
  final ApiRestaurantModel searchResult;

  RestaurantSearchResult(this.searchResult);

  @override
  List<Object> get props => [searchResult];
}

class RestaurantSearchError extends RestaurantSearchState {
  final String? message;
  const RestaurantSearchError(this.message);
}
