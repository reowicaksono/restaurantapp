import 'dart:convert';

ApiRestaurantModel apiRestaurantModelFromJson(String str) =>
    ApiRestaurantModel.fromJson(json.decode(str));

String apiRestaurantModelToJson(ApiRestaurantModel data) =>
    json.encode(data.toJson());

class ApiRestaurantModel {
  bool? error;
  String? message;
  int? count;
  List<Restaurant>? restaurants;

  ApiRestaurantModel({
    this.error,
    this.message,
    this.count,
    this.restaurants,
  });

  ApiRestaurantModel.withError(String errorMessage) {
    error = true;
    message = errorMessage;
  }

  factory ApiRestaurantModel.fromJson(Map<String, dynamic> json) =>
      ApiRestaurantModel(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: json["restaurants"] == null
            ? []
            : List<Restaurant>.from(
                json["restaurants"]!.map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": restaurants == null
            ? []
            : List<dynamic>.from(restaurants!.map((x) => x.toJson())),
      };
}

class Restaurant {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
