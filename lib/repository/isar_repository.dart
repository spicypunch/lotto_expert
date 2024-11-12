import 'package:isar/isar.dart';

import '../model/lotto_model.dart';

class IsarRepository {
  final Isar isar;

  IsarRepository(
    this.isar,
  );

  Future<void> saveLottoData(
      String title, List<int> sortedNum, Map<int, int> numMap) async {
    final lottoData = LottoModel()
      ..title = title
      ..sortedNum = sortedNum;
    lottoData.setNumMap(numMap);

    await isar.writeTxn(() async {
      await isar.lottoModels.put(lottoData);
    });
  }

  Future<List<LottoModel>> getAllLottoData() async {
    return await isar.lottoModels.where().findAll();
  }

  Future<void> deleteItem(int id) async {
    await isar.writeTxn(() async {
      await isar.lottoModels.delete(id);
    });
  }
}
