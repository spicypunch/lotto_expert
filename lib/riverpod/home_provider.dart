import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/model/lotto_model.dart';
import 'package:lotto_expert/model/lotto_number_response.dart';
import 'package:lotto_expert/repository/lotto_repository.dart';

import '../repository/isar_repository.dart';

class LottoNumberState {
  Map<int, int>? frequencyNumberMap;
  List<int>? sortedNumbers;
  String? dialogTitle;

  LottoNumberState({
    this.frequencyNumberMap,
    this.sortedNumbers,
    this.dialogTitle,
  });
}

final homeProvider = AutoDisposeStateNotifierProvider<HomeProvider,
    AsyncValue<LottoNumberState>>((ref) {
  final lottoRepository = ref.watch(lottoRepositoryProvider);
  final isarRepository = ref.watch(isarRepositoryProvider);
  return HomeProvider(
    lottoRepository: lottoRepository,
    isarRepository: isarRepository,
  );
});

class HomeProvider extends StateNotifier<AsyncValue<LottoNumberState>> {
  final LottoRepository lottoRepository;
  final IsarRepository isarRepository;

  HomeProvider({
    required this.lottoRepository,
    required this.isarRepository,
  }) : super(AsyncValue.data(LottoNumberState()));

  Future<void> getLottoNumber(
    int startNo,
    int endNo,
  ) async {
    state = const AsyncValue.loading();
    try {
      Map<int, int> numberFrequency = {};

      for (int i = startNo; i <= endNo; i++) {
        final response = await lottoRepository.getLottoNumber(drwNo: i);
        final jsonData = jsonDecode(response);
        final lottoModel = LottoNumberResponse.fromJson(jsonData);

        final List<int> lottoNumbers = [
          lottoModel.drwtNo1,
          lottoModel.drwtNo2,
          lottoModel.drwtNo3,
          lottoModel.drwtNo4,
          lottoModel.drwtNo5,
          lottoModel.drwtNo6,
        ];

        for (var number in lottoNumbers) {
          numberFrequency[number] = (numberFrequency[number] ?? 0) + 1;
        }
      }

      // 번호를 빈도 순으로 정렬
      List<int> sortedNumbers = numberFrequency.keys.toList()
        ..sort((a, b) => numberFrequency[b]!.compareTo(numberFrequency[a]!));

      state = AsyncValue.data(
        LottoNumberState(
          frequencyNumberMap: numberFrequency,
          sortedNumbers: sortedNumbers,
          dialogTitle: '$startNo회차 ~ $endNo회차',
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> saveLottoNumber(
    String title,
    List<int> sortedNum,
    Map<int, int> numMap,
  ) async {
    await isarRepository.saveLottoData(
      title,
      sortedNum,
      numMap,
    );
  }
}
