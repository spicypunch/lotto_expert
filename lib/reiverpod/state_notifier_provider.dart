import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/model/lotto_model.dart';

final lottoNumberListProvider =
    StateNotifierProvider<LottoNumberListNotifier, List<LottoModel>>(
  (ref) => LottoNumberListNotifier(),
);

class LottoNumberListNotifier extends StateNotifier<List<LottoModel>> {
  LottoNumberListNotifier()
      : super(
          [],
        );
  void getLottoNumber({required int startNum, required int endNum}) {
  }
}
