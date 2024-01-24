part of 'package:restaurant_app/view/pages.dart';

class ErrorWidget extends StatelessWidget {
  final VoidCallback? onRefresh;
  final String? message;

  const ErrorWidget({Key? key, this.onRefresh, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: onRefresh,
          child: Text(
            message ?? "Not Found Data",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
