import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:restaurant_app/domain/models/restaurant_models_api.dart';
import 'package:restaurant_app/domain/services/restaurant__api.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'Testing Restaurant Api',
    () {
      test('if http call complete success return ApiRestaurantModel', () async {
        final client = MockClient((request) async {
          final response = {
            "error": false,
            "message": "success",
            "count": 20,
            "restaurants": []
          };
          return Response(json.encode(response), 200);
        });
        expect(
          await RestaurantAPI().fetchAllRestaurant(),
          isA<ApiRestaurantModel>(),
        );
      });
    },
  );
}
