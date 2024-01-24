import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/domain/models/restaurant_models_api.dart';
import 'package:restaurant_app/domain/services/restaurant__api.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(RestaurantInitial()) {
    final RestaurantAPI _restaurantapi = RestaurantAPI();

    on<GetRestaurantList>((event, emit) async {
      try {
        emit(RestaurantLoading());
        final mList = await _restaurantapi.fetchAllRestaurant();

        emit(RestaurantLoaded(mList));
        if (mList.error != null && mList.error!) {
          emit(RestaurantError(mList.message));
        }
      } on NetworkError {
        emit(RestaurantError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
