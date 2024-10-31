import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> getLottoNumber(int startNo, int endNo) async {
    state = const AsyncValue.loading();
    try {
      Map<int, int> numberFrequency = {};
      int batchSize = 5; // 한 번에 처리할 최대 요청 수

      // 각 회차 요청을 배치별로 병렬 실행
      for (int i = startNo; i <= endNo; i += batchSize) {
        // batchSize 만큼의 요청을 생성
        final batchFutures = List.generate(
          (i + batchSize > endNo ? endNo - i + 1 : batchSize),
              (index) {
            final drawNumber = i + index;
            return lottoRepository.getLottoNumber(drwNo: drawNumber).then((response) {
              final jsonData = jsonDecode(response);
              final lottoModel = LottoNumberResponse.fromJson(jsonData);
              return [
                lottoModel.drwtNo1,
                lottoModel.drwtNo2,
                lottoModel.drwtNo3,
                lottoModel.drwtNo4,
                lottoModel.drwtNo5,
                lottoModel.drwtNo6,
              ];
            });
          },
        );

        // 현재 배치의 모든 요청을 기다림
        final results = await Future.wait(batchFutures);

        // 모든 회차의 로또 번호를 빈도에 따라 기록
        for (var lottoNumbers in results) {
          for (var number in lottoNumbers) {
            numberFrequency[number] = (numberFrequency[number] ?? 0) + 1;
          }
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

  // Future<void> getLottoNumber(
  //     int startNo,
  //     int endNo,
  //     ) async {
  //   state = const AsyncValue.loading();
  //   try {
  //     Map<int, int> numberFrequency = {};
  //
  //     for (int i = startNo; i <= endNo; i++) {
  //       final response = await lottoRepository.getLottoNumber(drwNo: i);
  //       final jsonData = jsonDecode(response);
  //       final lottoModel = LottoNumberResponse.fromJson(jsonData);
  //
  //       final List<int> lottoNumbers = [
  //         lottoModel.drwtNo1,
  //         lottoModel.drwtNo2,
  //         lottoModel.drwtNo3,
  //         lottoModel.drwtNo4,
  //         lottoModel.drwtNo5,
  //         lottoModel.drwtNo6,
  //       ];
  //
  //       for (var number in lottoNumbers) {
  //         numberFrequency[number] = (numberFrequency[number] ?? 0) + 1;
  //       }
  //     }
  //
  //     // 번호를 빈도 순으로 정렬
  //     List<int> sortedNumbers = numberFrequency.keys.toList()
  //       ..sort((a, b) => numberFrequency[b]!.compareTo(numberFrequency[a]!));
  //
  //     state = AsyncValue.data(
  //       LottoNumberState(
  //         frequencyNumberMap: numberFrequency,
  //         sortedNumbers: sortedNumbers,
  //         dialogTitle: '$startNo회차 ~ $endNo회차',
  //       ),
  //     );
  //   } catch (error, stackTrace) {
  //     state = AsyncValue.error(error, stackTrace);
  //   }
  // }


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
