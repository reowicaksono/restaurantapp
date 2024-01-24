part of 'pages.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({required this.restaurantId, Key? key})
      : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late RestaurantDetailBloc _detailBloc;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<RestaurantDetailBloc>(context);
    _detailBloc.add(GetRestaurantDetail(widget.restaurantId));
  }

  Future<void> _refresh() async {
    _detailBloc.add(GetRestaurantDetail(widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Detail'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<RestaurantDetailBloc, RestaurantDetailState>(
          builder: (context, state) {
            if (state is RestaurantDetailLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RestaurantDetailLoaded) {
              return _buildDetailPage(context, state.apiRestaurantDetailModel);
            } else if (state is RestaurantDetailError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return Center(
                  child: Container(
                child: Text("Oops Tidak Ada Page Yang Kamu Cari :("),
              ));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailPage(
      BuildContext context, ApiDetailRestaurantModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Hero(
            tag: 'restaurant_image_${model.restaurant!.pictureId}',
            child: Image.network(
              URL_IMAGE + "${model.restaurant!.pictureId}",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.restaurant!.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 18),
                    Text('${model.restaurant!.city}'),
                    const SizedBox(width: 8),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text('${model.restaurant!.rating ?? 0.0}'),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                Text(
                  'Description',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  '${model.restaurant!.description}',
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(color: Colors.grey),
                Text(
                  'Menus',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text('Foods: '),
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.restaurant!.menus!.foods!.length,
                    itemBuilder: (context, index) {
                      if (index < model.restaurant!.menus!.foods!.length) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${model.restaurant!.menus!.foods![index].name}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text('Drinks: '),
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.restaurant!.menus!.drinks!.length,
                    itemBuilder: (context, index) {
                      if (index < model.restaurant!.menus!.drinks!.length) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${model.restaurant!.menus!.drinks![index].name}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildReviews(model),
          _buildAddReviewForm(),
        ],
      ),
    );
  }

  Widget _buildReviews(ApiDetailRestaurantModel model) {
    if (model.restaurant?.customerReviews != null &&
        model.restaurant!.customerReviews!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: model.restaurant!.customerReviews!.length,
              itemBuilder: (context, index) {
                var review = model.restaurant!.customerReviews![index];
                return Card(
                  elevation: 3.0,
                  child: ListTile(
                    title: Text(review.name!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('"${review.review!}"'),
                        const SizedBox(height: 4),
                        Text(review.date!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildAddReviewForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Your Review',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Your Name',
            ),
          ),
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: 'Write your review...',
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameController.text;
                  final reviewText = _reviewController.text;
                  if (name.isNotEmpty && reviewText.isNotEmpty) {
                    _detailBloc.add(AddReviewEvent(
                      restaurantId: widget.restaurantId,
                      name: name,
                      review: reviewText,
                    ));
                    _nameController.clear();
                    _reviewController.clear();
                    _showDialog(
                        title: "Success", message: "Success Add Review :).");
                  } else {
                    _showDialog(
                        title: "Failed",
                        message: "Please fill in both name and review.");
                  }
                },
                child: Center(child: const Text('Submit Review')),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showDialog(
      {String message = "Test", String title = "Submission Failed"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
