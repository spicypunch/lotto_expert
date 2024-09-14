import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/common/dio/dio.dart';
import 'package:lotto_expert/model/lotto_number_response.dart';
import 'package:retrofit/http.dart';

part 'lotto_repository.g.dart';


final lottoRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return LottoRepository(dio, baseUrl: "http://www.dhlottery.co.kr/common.do");
}) ;

@RestApi()
abstract class LottoRepository {
  factory LottoRepository(Dio dio, {String baseUrl}) = _LottoRepository;

  @GET('/')
  Future<String> getLottoNumber({
    @Query('method') String method = 'getLottoNumber',
    @Query('drwNo') required int drwNo,
  });
}
