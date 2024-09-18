import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/lotto_model.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  if (Isar.instanceNames.isEmpty) {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [LottoModelSchema],
      inspector: true,
      directory: dir.path,
    );
  }
  return Future.value(Isar.getInstance());
});