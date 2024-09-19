import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/common/const/colors.dart';
import 'package:lotto_expert/common/layout/default_layout.dart';

import '../common/layout/default_button.dart';
import '../common/layout/default_dialog.dart';
import '../riverpod/home_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _startNoController = TextEditingController();
  final TextEditingController _endNoController = TextEditingController();
  bool _showDialog = false;

  @override
  void dispose() {
    _startNoController.dispose();
    _endNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    return DefaultLayout(
      child: Center(
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
                  const SizedBox(
                    width: 16.0,
                  ),
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
                  FocusScope.of(context).unfocus();

                  if(_startNoController.text.isEmpty || _endNoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('시작 번호와 끝 번호를 모두 입력해주세요.'),
                      ),
                    );
                    return;
                  }
                  final startNo = int.tryParse(_startNoController.text) ?? 0;
                  final endNo = int.tryParse(_endNoController.text) ?? 0;

                  if (startNo <= endNo) {
                    ref.read(homeProvider.notifier).getLottoNumber(
                          startNo,
                          endNo,
                        );
                    _showDialog = false;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('시작 번호는 끝 번호보다 작거나 같아야 합니다.'),
                      ),
                    );
                  }
                },
                backgroundColor: BUTTON_COLOR,
                foregroundColor: PRIMARY_BLACK,
              ),
              const SizedBox(
                height: 16.0,
              ),
              state.when(
                data: (lottoState) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      if (!_showDialog &&
                          lottoState.frequencyNumberMap != null &&
                          lottoState.frequencyNumberMap!.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DefaultDialog(
                              title: lottoState.dialogTitle!,
                              sortedNum: lottoState.sortedNumbers!,
                              numMap: lottoState.frequencyNumberMap!,
                              onTabButton: () {
                                ref
                                    .read(homeProvider.notifier)
                                    .saveLottoNumber(
                                      lottoState.dialogTitle!,
                                      lottoState.sortedNumbers!,
                                      lottoState.frequencyNumberMap!,
                                    );
                              },
                            );
                          },
                        );
                      }
                      _showDialog = true;
                    },
                  );
                  return const SizedBox.shrink();
                },
                error: (err, stack) => Text('Error: $err'),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: GRAY,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
