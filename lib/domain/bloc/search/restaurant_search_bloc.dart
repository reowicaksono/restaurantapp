import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/domain/models/restaurant_models_api.dart';
import 'package:restaurant_app/domain/services/restaurant__api.dart';

part 'restaurant_search_event.dart';
part 'restaurant_search_state.dart';

class RestaurantSearchBloc
    extends Bloc<RestaurantSearchEvent, RestaurantSearchState> {
  final RestaurantAPI _restaurantapi = RestaurantAPI();

  RestaurantSearchBloc() : super(RestaurantSearchInitial()) {
    on<SearchRestaurant>((event, emit) async {
      try {
        emit(RestaurantSearchLoading());
        final searchResult = await _restaurantapi.searchRestaurant(event.query);
        emit(RestaurantSearchResult(searchResult));
        if (searchResult.error != null && searchResult.error!) {
          emit(RestaurantSearchError(searchResult.message));
        }
      } catch (e) {
        emit(RestaurantSearchError("Failed to search restaurants"));
      } on NetworkError {
        emit(RestaurantSearchError(
            "Failed to fetch data. is your device online?"));
      }
    });
    on<ResetSearch>((event, emit) async {
      emit(RestaurantSearchInitial());
    });
  }

  @override
  Stream<RestaurantSearchState> mapEventToState(
    RestaurantSearchEvent event,
  ) async* {
    if (event is SearchRestaurant) {
      try {
        final searchResult = await _restaurantapi.searchRestaurant(event.query);
        yield RestaurantSearchResult(searchResult);
      } catch (e) {
        yield RestaurantSearchError("Failed to search restaurants");
      }
    }
  }
}
