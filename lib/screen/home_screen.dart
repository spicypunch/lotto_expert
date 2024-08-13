import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lotto_expert/common/const/colors.dart';
import 'package:lotto_expert/repository/lotto_repository.dart';

import '../common/dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _startNoController = TextEditingController();
  final TextEditingController _endNoController = TextEditingController();

  Future<List<String>>? _getLottoNumbersFuture;

  Future<List<String>> getLottoNumbers(int startNo, int endNo) async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(),
    );

    // 비동기 요청 리스트
    List<Future<String>> futureList = [];

    for (int i = startNo; i <= endNo; i++) {
      futureList.add(
        LottoRepository(dio, baseUrl: "http://www.dhlottery.co.kr/common.do")
            .getLottoNumber(drwNo: i),
      );
    }

    return await Future.wait(futureList);
  }

  @override
  void dispose() {
    _startNoController.dispose();
    _endNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startNoController,
                      decoration: const InputDecoration(
                        labelText: '로또 회차 시작',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _endNoController,
                      decoration: const InputDecoration(
                        labelText: '로또 회차 끝',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final startNo = int.tryParse(_startNoController.text) ?? 0;
                  final endNo = int.tryParse(_endNoController.text) ?? 0;

                  if (startNo <= endNo) {
                    setState(() {
                      _getLottoNumbersFuture = getLottoNumbers(startNo, endNo);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('시작 번호는 끝 번호보다 작거나 같아야 합니다.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BUTTON_COLOR,
                  foregroundColor: PRIMARY_BLACK,
                ),
                child: const Text('조회'),
              ),
              const SizedBox(
                height: 16.0,
              ),
              if (_getLottoNumbersFuture != null)
                FutureBuilder<List<String>>(
                  future: _getLottoNumbersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final lottoDataList = snapshot.data!;
                      return Column(
                        children: lottoDataList
                            .map((lottoData) => Text('로또 번호: $lottoData'))
                            .toList(),
                      );
                    } else {
                      return const Text('데이터가 없다');
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
