import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/domain/models/restaurant_models_detail_api.dart';
import 'package:restaurant_app/domain/services/restaurant__api.dart';

part 'restaurant_detail_event.dart';
part 'restaurant_detail_state.dart';

class RestaurantDetailBloc
    extends Bloc<RestaurantDetailEvent, RestaurantDetailState> {
  final RestaurantAPI _restaurantapi = RestaurantAPI();

  RestaurantDetailBloc() : super(RestaurantDetailInitial()) {
    on<GetRestaurantDetail>((event, emit) async {
      try {
        emit(RestaurantDetailLoading());
        final restaurantDetail =
            await _restaurantapi.fetchRestaurantDetail(event.restaurantId);
        emit(RestaurantDetailLoaded(restaurantDetail));

        if (restaurantDetail.error != null && restaurantDetail.error!) {
          emit(RestaurantDetailError(restaurantDetail.message));
        }
      } on NetworkError {
        emit(RestaurantDetailError(
            "Failed to fetch data. Is your device online?"));
      }
    });
    on<AddReviewEvent>((event, emit) async {
      try {
        await _restaurantapi.addRestaurantReview(
          event.restaurantId,
          event.name,
          event.review,
        );

        final updatedDetail =
            await _restaurantapi.fetchRestaurantDetail(event.restaurantId);
        emit(RestaurantDetailLoaded(updatedDetail));
      } catch (e) {
        emit(RestaurantDetailError("Failed to add review"));
      }
    });
  }

  @override
  Stream<RestaurantDetailState> mapEventToState(
    RestaurantDetailEvent event,
  ) async* {
    if (event is AddReviewEvent) {
      try {
        await _restaurantapi.addRestaurantReview(
          event.restaurantId,
          event.name,
          event.review,
        );

        final updatedDetail =
            await _restaurantapi.fetchRestaurantDetail(event.restaurantId);
        yield RestaurantDetailLoaded(updatedDetail);
      } catch (e) {
        yield RestaurantDetailError("Failed to add review");
      }
    }
  }
}
