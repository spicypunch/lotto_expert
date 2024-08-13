import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../model/lotto_model.dart';

part 'lotto_repository.g.dart';

@RestApi()
abstract class LottoRepository {
  factory LottoRepository(Dio dio, {String baseUrl}) = _LottoRepository;

  @GET('/')
  Future<String> getLottoNumber({
    @Query('method') String method = 'getLottoNumber',
    @Query('drwNo') required int drwNo,
  });
}
