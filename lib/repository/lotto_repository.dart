import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'lotto_repository.g.dart';


@RestApi(baseUrl: "http://www.dhlottery.co.kr/common.do")
abstract class LottoRepository {
  factory LottoRepository(Dio dio, {String baseUrl}) = _LottoRepository;

  @GET('/')
  Future<String> getLottoNumber({
    @Query('method') String method = 'getLottoNumber',
    @Query('drwNo') required int drwNo,
  });
}
