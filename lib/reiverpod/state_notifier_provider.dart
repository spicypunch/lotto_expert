import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/repository/lotto_repository.dart';

class LottoNumberState {
  List<Map<String, dynamic>>? list;

  LottoNumberState({
    this.list,
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
  }) : super(const AsyncValue.loading());

  Future<void> getLottoNumber({
    required int startNo,
    required int endNo,
  }) async {
    state = const AsyncValue.loading();
    try {
      List<Map<String, dynamic>> lottoNumbers = [];
      for (int i = startNo; i <= endNo; i++) {
        final response = await lottoRepository.getLottoNumber(drwNo: i);
        final jsonData = jsonDecode(response);
        lottoNumbers.add(jsonData);
      }
      // state = AsyncValue.data(LottoNumberState(list: lottoNumbers));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace: stackTrace);
    }
  }


}
