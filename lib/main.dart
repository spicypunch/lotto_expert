import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotto_expert/repository/isar_repository.dart';
import 'package:lotto_expert/repository/lotto_repository.dart';
import 'package:lotto_expert/screen/root_screen.dart';
import 'package:lotto_expert/bloc/home_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'model/lotto_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio(); // Dio 인스턴스 직접 생성
  dio.interceptors.add(LogInterceptor(responseBody: true));
  final lottoRepository = LottoRepository(dio, baseUrl: "http://www.dhlottery.co.kr/common.do");

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [LottoModelSchema],
    inspector: true,
    directory: dir.path,
  );

  runApp(MyApp(isar: isar, lottoRepository: lottoRepository));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  final LottoRepository lottoRepository;

  MyApp({required this.isar, required this.lottoRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => lottoRepository), // LottoRepository 주입
        RepositoryProvider(create: (_) => IsarRepository(isar)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(
              lottoRepository: context.read<LottoRepository>(),
              isarRepository: context.read<IsarRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: RootScreen(),
        ),
      ),
    );
  }
}
