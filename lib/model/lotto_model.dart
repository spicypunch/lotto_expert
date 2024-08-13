import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'lotto_model.g.dart';

@JsonSerializable()
class LottoModel {
  final int drwNo;
  final String drwNoDate;
  final int drwtNo1;
  final int drwtNo2;
  final int drwtNo3;
  final int drwtNo4;
  final int drwtNo5;
  final int drwtNo6;
  final int bnusNo;
  final int firstPrzwnerCo;
  final String returnValue;
  final int totSellamnt;

  LottoModel({
    required this.drwNo,
    required this.drwNoDate,
    required this.drwtNo1,
    required this.drwtNo2,
    required this.drwtNo3,
    required this.drwtNo4,
    required this.drwtNo5,
    required this.drwtNo6,
    required this.bnusNo,
    required this.firstPrzwnerCo,
    required this.returnValue,
    required this.totSellamnt,
  });

  factory LottoModel.fromJson(Map<String, dynamic> json) =>
      _$LottoModelFromJson(json);
}

/**
 * package kr.jm.lottoexpert.data


    import kotlinx.parcelize.Parcelize
    import android.os.Parcelable

    @Parcelize
    data class LottoNumber(
    val bnusNo: Int, // 2
    val drwNo: Int, // 1109
    val drwNoDate: String, // 2024-03-02
    val drwtNo1: Int, // 10
    val drwtNo2: Int, // 12
    val drwtNo3: Int, // 13
    val drwtNo4: Int, // 19
    val drwtNo5: Int, // 33
    val drwtNo6: Int, // 40
    //    val firstAccumamnt: Long, // 26933998875
    val firstPrzwnerCo: Int, // 17
    //    val firstWinamnt: Int, // 1584352875
    val returnValue: String, // success
    val totSellamnt: Long // 117196327000
    ) : Parcelable
 */
