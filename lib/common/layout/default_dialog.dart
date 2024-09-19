import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  final String title;
  final List<int> sortedNum;
  final Map<int, int> numMap;
  final Function()? onTabButton;

  const DefaultDialog({
    required this.title,
    required this.sortedNum,
    required this.numMap,
    this.onTabButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sortedNum.length,
                itemBuilder: (context, index) {
                  final number = sortedNum[index];
                  final frequency = numMap[number];
                  return ListTile(
                    title: Text('번호: $number'),
                    subtitle: Text('당첨 횟수: $frequency'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (onTabButton != null)
              ElevatedButton(
                onPressed: () {
                  onTabButton!();
                  Navigator.of(context).pop();
                },
                child: const Text('정보 저장'),
              ),
          ],
        ),
      ),
    );
    ;
  }
}
