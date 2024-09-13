import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/common/const/colors.dart';
import 'package:lotto_expert/reiverpod/state_notifier_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _startNoController = TextEditingController();
  final TextEditingController _endNoController = TextEditingController();

  @override
  void dispose() {
    _startNoController.dispose();
    _endNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lottoNumberProvider);

    return Scaffold(
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
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
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
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final startNo = int.tryParse(_startNoController.text) ?? 0;
                  final endNo = int.tryParse(_endNoController.text) ?? 0;

                  if (startNo <= endNo) {
                    ref.read(lottoNumberProvider.notifier).getLottoNumber(
                      startNo: startNo,
                      endNo: endNo,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('시작 번호는 끝 번호보다 작거나 같아야 합니다.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BUTTON_COLOR,
                  foregroundColor: PRIMARY_BLACK,
                ),
                child: const Text('조회'),
              ),
              const SizedBox(
                height: 16.0,
              ),
              state.when(
                data: (lottoState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (lottoState.frequencyNumberMap != null &&
                        lottoState.frequencyNumberMap!.isNotEmpty) {

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${lottoState.dialogTitle}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: lottoState.sortedNumbers?.length,
                                      itemBuilder: (context, index) {
                                        final number = lottoState.sortedNumbers?[index];
                                        final frequency = lottoState.frequencyNumberMap![number];
                                        return ListTile(
                                          title: Text('번호: $number'),
                                          subtitle: Text('당첨 횟수: $frequency'),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                    },
                                    child: const Text('정보 저장'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  });

                  // UI에 별도의 내용은 표시하지 않음
                  return const SizedBox.shrink();
                },
                error: (err, stack) => Text('Error: $err'),
                loading: () => const Center(
                  child: CircularProgressIndicator(), // 로딩 중일 때 표시
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
