import 'dart:io';

import 'package:dio/dio.dart';
import 'package:restaurant_app/domain/models/restaurant_models_api.dart';
import 'package:restaurant_app/domain/models/restaurant_models_detail_api.dart';
import 'package:restaurant_app/utils/app_constants.dart';

class RestaurantAPI {
  final Dio _dio = Dio();

  Future<ApiRestaurantModel> fetchAllRestaurant() async {
    try {
      Response response = await _dio.get(BASE_URL_API + "list");

      return ApiRestaurantModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          return ApiRestaurantModel.withError("No internet connection");
        }
      }
      return ApiRestaurantModel.withError("An error occurred");
    }
  }

  Future<ApiDetailRestaurantModel> fetchRestaurantDetail(
      String restaurantId) async {
    try {
      Response response = await _dio.get(BASE_URL_API + "detail/$restaurantId");
      return ApiDetailRestaurantModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          return ApiDetailRestaurantModel.withError("No internet connection");
        }
      }
      return ApiDetailRestaurantModel.withError("An error occurred");
    }
  }

  Future<ApiRestaurantModel> searchRestaurant(String query) async {
    try {
      Response response = await _dio.get(BASE_URL_API + "search?q=$query");
      return ApiRestaurantModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          return ApiRestaurantModel.withError("No internet connection");
        }
      }
      return ApiRestaurantModel.withError("An error occurred");
    }
  }

  Future<ApiDetailRestaurantModel> addRestaurantReview(
      String restaurantId, String name, String review) async {
    try {
      final Map<String, dynamic> requestBody = {
        "id": restaurantId,
        "name": name,
        "review": review,
      };

      Response response =
          await _dio.post(BASE_URL_API + "review", data: requestBody);

      return ApiDetailRestaurantModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          return ApiDetailRestaurantModel.withError("No internet connection");
        }
      }
      return ApiDetailRestaurantModel.withError("An error occurred");
    }
  }
}

class NetworkError extends Error {}
