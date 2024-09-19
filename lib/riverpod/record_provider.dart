import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/model/lotto_model.dart';
import 'package:lotto_expert/repository/isar_repository.dart';

final recordProvider = AutoDisposeStateNotifierProvider<
    RecordProvider,
    List<LottoModel>>((ref) {
  final isarRepository = ref.watch(isarRepositoryProvider);
  return RecordProvider(isarRepository: isarRepository);
});


class RecordProvider extends StateNotifier<List<LottoModel>> {
  IsarRepository isarRepository;

  RecordProvider({
    required this.isarRepository,
  }) : super([]);

  Future<void> getAllLottoData() async {
    final allLottoData = await isarRepository.getAllLottoData();
    state = allLottoData;
  }
}