import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();

  // dio.interceptors.add(
  //   InterceptorsWrapper(
  //     onRequest: (options, handler) {
  //       // Request 인터셉터 로직
  //       print('onRequest');
  //       return handler.next(options);
  //     },
  //     onResponse: (response, handler) {
  //       // Response 인터셉터 로직 (이전에 작성한 코드)
  //       if (response.data is String) {
  //         print('onResponse');
  //         response.data = jsonDecode(response.data);
  //       }
  //       return handler.next(response);
  //     },
  //     onError: (DioError e, handler) {
  //       // Error 인터셉터 로직
  //       print('onError');
  //       return handler.next(e);
  //     },
  //   ),
  // );

  dio.interceptors.add(CustomInterceptor());

  return dio;
});

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    return handler.reject(err);
  }
}
