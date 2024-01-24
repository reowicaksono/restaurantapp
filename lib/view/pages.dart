import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:restaurant_app/domain/bloc/favorites/favorite_bloc.dart';
import 'package:restaurant_app/domain/bloc/list/restaurant__bloc.dart';
import 'package:restaurant_app/domain/bloc/notification/notification_bloc.dart';
import 'package:restaurant_app/domain/bloc/search/restaurant_search_bloc.dart';

import 'package:restaurant_app/domain/models/restaurant_models_api.dart' as api;
import 'package:restaurant_app/domain/models/restaurant_models_detail_api.dart';

import 'package:restaurant_app/domain/bloc/detail/restaurant_detail_bloc.dart';

import 'package:restaurant_app/utils/app_constants.dart';
import 'package:restaurant_app/utils/app_preferences.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/view/favorite_restaurant.dart';

part 'detail_restaurant.dart';
part 'list_restaurant.dart';
part 'splash_screen.dart';
part '../widget/error.dart';
part 'dashboard_restaurant.dart';
part 'settings_restaurant.dart';
