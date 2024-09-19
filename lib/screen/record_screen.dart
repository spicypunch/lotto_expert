import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/common/layout/default_dialog.dart';
import 'package:lotto_expert/common/layout/default_layout.dart';

import '../riverpod/record_provider.dart';

class RecordScreen extends ConsumerWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(recordProvider.notifier).getAllLottoData();
    final state = ref.watch(recordProvider);

    return SafeArea(
      child: DefaultLayout(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: state.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      state[index].title!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      final numMap = state[index].getNumMap();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DefaultDialog(
                            title: state[index].title!,
                            sortedNum: state[index].sortedNum!,
                            numMap: numMap!,
                          );
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}