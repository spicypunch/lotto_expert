import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    final url = 'https://www.dhlottery.co.kr/common.do';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final response = await dio.get(
                  url,
                  queryParameters: {'method': 'getLottoNumber', 'drwNo': 1130},
                );
                print(response.data);
              },
              child: Text('Button'),
            ),
          ],
        ),
      ),
    );
  }
}
