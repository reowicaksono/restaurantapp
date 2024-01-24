part of 'pages.dart';

class ListRestaurant extends StatefulWidget {
  const ListRestaurant({Key? key}) : super(key: key);

  @override
  State<ListRestaurant> createState() => _ListRestaurantState();
}

class _ListRestaurantState extends State<ListRestaurant> {
  final RestaurantBloc _newsBloc = RestaurantBloc();
  final RestaurantSearchBloc _searchBloc = RestaurantSearchBloc();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    _newsBloc.add(GetRestaurantList());

    super.initState();
  }

  Future<void> _refresh() async {
    _newsBloc.add(GetRestaurantList());
    _searchBloc.add(ResetSearch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantSearchBloc>(
      create: (context) => _searchBloc,
      child: BlocProvider.value(
        // Add this line
        value: _newsBloc,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Restaurant',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Recommendation restaurant for you!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
            backgroundColor: Colors.amber,
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _showSearchDialog(context);
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: _buildListRestaurant(),
          ),
        ),
      ),
    );
  }

  Widget _buildListRestaurant() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocListener<RestaurantBloc, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantError) {
            _showSnackBar(context, state.message!);
          }
        },
        child: BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantInitial || state is RestaurantLoading) {
              return _buildLoading();
            } else if (state is RestaurantLoaded) {
              return _buildCard(context, state.apiRestaurantModel);
            } else if (state is RestaurantError) {
              return Container(
                  child:
                      ErrorWidget(onRefresh: _refresh, message: state.message));
            } else {
              return ErrorWidget(
                onRefresh: _refresh,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, api.ApiRestaurantModel model) {
    return BlocBuilder<RestaurantSearchBloc, RestaurantSearchState>(
      builder: (context, searchState) {
        return BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, favoriteState) {
            if (searchState is RestaurantSearchResult) {
              if (searchState.searchResult != null &&
                  searchState.searchResult.restaurants != null &&
                  searchState.searchResult.restaurants!.isNotEmpty) {
                return _buildSearchResults(
                    searchState.searchResult.restaurants!);
              } else {
                return ErrorWidget(onRefresh: _refresh);
              }
            } else if (searchState is RestaurantSearchError) {
              return ErrorWidget(
                onRefresh: _refresh,
                message: searchState.message,
              );
            } else if (searchState is RestaurantSearchLoading) {
              return _buildLoading();
            } else {
              return ListView.builder(
                itemCount: model.restaurants?.length,
                itemBuilder: (context, index) {
                  String restaurantId = model.restaurants![index].id!;
                  bool isFavorite = (favoriteState is FavoriteLoaded) &&
                      favoriteState.favorites
                          .any((fav) => fav.id == restaurantId);

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(
                            restaurantId: restaurantId,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    leading: Hero(
                      tag:
                          'restaurant_image_${model.restaurants![index].pictureId}',
                      child: Image.network(
                        URL_IMAGE + "${model.restaurants![index].pictureId}",
                        width: 100,
                        errorBuilder: (ctx, error, _) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                    title: Text("${model.restaurants![index].name}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.grey, size: 18),
                            Text("${model.restaurants![index].city}"),
                            const SizedBox(width: 8),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                            Text('${model.restaurants![index].rating ?? 0.0}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: isFavorite
                        ? IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              BlocProvider.of<FavoriteBloc>(context).add(
                                RemoveFavoriteEvent(
                                  restaurantId: restaurantId,
                                ),
                              );
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                            ),
                            onPressed: () {
                              BlocProvider.of<FavoriteBloc>(context).add(
                                AddFavoriteEvent(
                                  restaurant: model.restaurants![index],
                                ),
                              );
                            },
                          ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Restaurant'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter restaurant name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _searchBloc.add(SearchRestaurant(_searchController.text));
                Navigator.pop(context);
                _searchController.clear();
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(List<api.Restaurant> restaurants) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, favoriteState) {
      return ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          String restaurantId = restaurants![index].id!;
          bool isFavorite = (favoriteState is FavoriteLoaded) &&
              favoriteState.favorites.any((fav) => fav.id == restaurantId);
          return ListTile(
            onTap: () {
              context.read<RestaurantSearchBloc>().add(ResetSearch());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailPage(
                    restaurantId: restaurants[index].id!,
                  ),
                ),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Hero(
              tag: 'restaurant_image_${restaurants[index].pictureId}',
              child: Image.network(
                URL_IMAGE + "${restaurants[index].pictureId}",
                width: 100,
                errorBuilder: (ctx, error, _) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            title: Text("${restaurants[index].name}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 18),
                    Text("${restaurants[index].city}"),
                    const SizedBox(width: 8),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text('${restaurants[index].rating ?? 0.0}'),
                  ],
                ),
              ],
            ),
            trailing: isFavorite
                ? IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      BlocProvider.of<FavoriteBloc>(context).add(
                        RemoveFavoriteEvent(
                          restaurantId: restaurantId,
                        ),
                      );
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                    ),
                    onPressed: () {
                      BlocProvider.of<FavoriteBloc>(context).add(
                        AddFavoriteEvent(
                          restaurant: restaurants![index],
                        ),
                      );
                    },
                  ),
          );
        },
      );
    });
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
