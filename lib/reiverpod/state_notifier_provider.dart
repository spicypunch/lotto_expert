import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/model/lotto_model.dart';
import 'package:lotto_expert/repository/lotto_repository.dart';

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

final lottoNumberProvider = AutoDisposeStateNotifierProvider<
    LottoNumberProvider, AsyncValue<LottoNumberState>>((ref) {
  final lottoRepository = ref.watch(lottoRepositoryProvider);
  return LottoNumberProvider(lottoRepository: lottoRepository);
});

class LottoNumberProvider extends StateNotifier<AsyncValue<LottoNumberState>> {
  final LottoRepository lottoRepository;

  LottoNumberProvider({
    required this.lottoRepository,
  }) : super(AsyncValue.data(LottoNumberState()));

  Future<void> getLottoNumber({
    required int startNo,
    required int endNo,
  }) async {
    state = const AsyncValue.loading();
    try {
      Map<int, int> numberFrequency = {};
      // List<int> allNumbers = [];

      for (int i = startNo; i <= endNo; i++) {
        final response = await lottoRepository.getLottoNumber(drwNo: i);
        final jsonData = jsonDecode(response);
        final lottoModel = LottoModel.fromJson(jsonData);

        // drwtNo1부터 drwtNo6까지 추출
        final List<int> lottoNumbers = [
          lottoModel.drwtNo1,
          lottoModel.drwtNo2,
          lottoModel.drwtNo3,
          lottoModel.drwtNo4,
          lottoModel.drwtNo5,
          lottoModel.drwtNo6,
        ];

        // 번호를 리스트에 추가
        // allNumbers.addAll(lottoNumbers);

        // 각 번호의 등장 횟수를 계산
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
      state = AsyncValue.error(error, stackTrace: stackTrace);
    }
  }
}
