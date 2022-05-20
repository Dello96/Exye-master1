import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  const CustomNetworkImage({required this.url, this.height, this.width, required this.fit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: Image.network(url,
        fit: fit,
        height: height,
        width: width,
        loadingBuilder: (context, child, load) {
          if (load == null) {
            return child;
          }
          else {
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
