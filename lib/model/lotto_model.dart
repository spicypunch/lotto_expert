import 'dart:convert';

import 'package:isar/isar.dart';

part 'lotto_model.g.dart';

@collection
class LottoModel {
  Id id = Isar.autoIncrement;

  String? title;

  List<int>? sortedNum;

  @Index(type: IndexType.value)
  String? numMapJson;

  void setNumMap(Map<int, int> map) {
    numMapJson = jsonEncode(map);
  }

  Map<int, int>? getNumMap() {
    if (numMapJson == null) return null;
    Map<String, dynamic> decodedMap = jsonDecode(numMapJson!);
    return decodedMap.map((key, value) => MapEntry(int.parse(key), value as int));
  }
}