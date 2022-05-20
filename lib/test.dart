import 'package:dio/dio.dart';

void main () async {
  final tmp1 = Future.delayed(Duration(seconds: 2), () {
    print(2);
    return 2;
  });
  final tmp2 = Future(() async {
    await tmp1;
    print(5);
    return 5;
  });
}