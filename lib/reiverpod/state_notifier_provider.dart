import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/repository/lotto_repository.dart';

final lottoNumberProvider = AutoDisposeStateNotifierProvider<
    LottoNumberProvider, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final lottoRepository = ref.watch(lottoRepositoryProvider);
  return LottoNumberProvider(lottoRepository: lottoRepository);
});

class LottoNumberProvider extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final LottoRepository lottoRepository;

  LottoNumberProvider({
    required this.lottoRepository,
  }) : super(const AsyncValue.loading()) {
  }

  Future<void> getLottoNumber({required int startNo, required int endNo}) async {
    List<Map<String, dynamic>> lottoNumbers = [];
    for (int i = startNo; i <= endNo; i++) {
      final response = await lottoRepository.getLottoNumber(drwNo: i);
      final jsonData = jsonDecode(response);
      lottoNumbers.add(jsonData);
    }
    state = AsyncValue.data(lottoNumbers);
  }
}
