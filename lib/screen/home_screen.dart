import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../common/const/colors.dart';
import '../common/layout/default_button.dart';
import '../common/layout/default_dialog.dart';
import '../repository/isar_repository.dart';
import '../repository/lotto_repository.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _startNoController = TextEditingController();
  final TextEditingController _endNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        lottoRepository: context.read<LottoRepository>(),
        isarRepository: context.read<IsarRepository>(),
      ),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startNoController,
                        decoration: const InputDecoration(
                          labelText: '로또 회차 시작',
                          labelStyle: TextStyle(color: PRIMARY_BLACK),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_BLACK),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        cursorColor: PRIMARY_BLACK,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: _endNoController,
                        decoration: const InputDecoration(
                          labelText: '로또 회차 끝',
                          labelStyle: TextStyle(color: PRIMARY_BLACK),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_BLACK),
                          ),
                          focusColor: PRIMARY_BLACK,
                        ),
                        keyboardType: TextInputType.number,
                        cursorColor: PRIMARY_BLACK,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DefaultButton(
                  title: '조회',
                  onTap: () {
                    final startNo = int.tryParse(_startNoController.text) ?? 0;
                    final endNo = int.tryParse(_endNoController.text) ?? 0;

                    if (startNo == 0 || endNo == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('시작 번호와 끝 번호를 모두 입력해주세요.')),
                      );
                      return;
                    }
                    if (startNo <= endNo) {
                      context
                          .read<HomeBloc>()
                          .add(FetchLottoNumbers(startNo, endNo));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('시작 번호는 끝 번호보다 작거나 같아야 합니다.')),
                      );
                    }
                  },
                  backgroundColor: BUTTON_COLOR,
                  foregroundColor: PRIMARY_BLACK,
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<HomeBloc, LottoNumberState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator();
                    } else if (state.errorMessage != null) {
                      return Text('Error: ${state.errorMessage}');
                    } else if (state.frequencyNumberMap != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DefaultDialog(
                              title: state.dialogTitle!,
                              sortedNum: state.sortedNumbers!,
                              numMap: state.frequencyNumberMap!,
                              onTabButton: () {
                                context.read<HomeBloc>().add(SaveLottoNumbers(
                                      state.dialogTitle!,
                                      state.sortedNumbers!,
                                      state.frequencyNumberMap!,
                                    ));
                              },
                            );
                          },
                        );
                      });
                      return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
