import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/lotto_model.dart';

final isarProvider = AsyncNotifierProvider<IsarNotifier, Isar?>(() {
  return IsarNotifier();
});

class IsarNotifier extends AsyncNotifier<Isar?> {
  @override
  Future<Isar?> build() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [LottoModelSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Isar.getInstance();
  }
}