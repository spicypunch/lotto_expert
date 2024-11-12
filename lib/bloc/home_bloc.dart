import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotto_expert/repository/lotto_repository.dart';
import 'package:lotto_expert/repository/isar_repository.dart';
import '../model/lotto_number_response.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, LottoNumberState> {
  final LottoRepository lottoRepository;
  final IsarRepository isarRepository;

  HomeBloc({
    required this.lottoRepository,
    required this.isarRepository,
  }) : super(LottoNumberState()) {
    on<FetchLottoNumbers>(_onFetchLottoNumbers);
    on<SaveLottoNumbers>(_onSaveLottoNumbers);
  }

  Future<void> _onFetchLottoNumbers(
    FetchLottoNumbers event,
    Emitter<LottoNumberState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      Map<int, int> numberFrequency = {};
      int batchSize = 5;

      for (int i = event.startNo; i <= event.endNo; i += batchSize) {
        final batchFutures = List.generate(
          (i + batchSize > event.endNo ? event.endNo - i + 1 : batchSize),
          (index) {
            final drawNumber = i + index;
            return lottoRepository
                .getLottoNumber(drwNo: drawNumber)
                .then((response) {
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

        final results = await Future.wait(batchFutures);
        for (var lottoNumbers in results) {
          for (var number in lottoNumbers) {
            numberFrequency[number] = (numberFrequency[number] ?? 0) + 1;
          }
        }
      }

      List<int> sortedNumbers = numberFrequency.keys.toList()
        ..sort((a, b) => numberFrequency[b]!.compareTo(numberFrequency[a]!));

      emit(state.copyWith(
        frequencyNumberMap: numberFrequency,
        sortedNumbers: sortedNumbers,
        dialogTitle: '${event.startNo}회차 ~ ${event.endNo}회차',
        isLoading: false,
      ));
    } catch (error) {
      print('에러');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onSaveLottoNumbers(
    SaveLottoNumbers event,
    Emitter<LottoNumberState> emit,
  ) async {
    await isarRepository.saveLottoData(
      event.title,
      event.sortedNum,
      event.numMap,
    );
  }
}
