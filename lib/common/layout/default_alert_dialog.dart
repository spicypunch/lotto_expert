import 'package:flutter/material.dart';

import '../const/colors.dart';
import 'default_button.dart';

class DefaultAlertDialog extends StatelessWidget {
  final String title;
  final Function() onTabConfirm;

  const DefaultAlertDialog({
    required this.title,
    required this.onTabConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: PRIMARY_BLACK,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: DefaultButton(
                title: '취소',
                onTap: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: GRAY,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: DefaultButton(
                title: '확인',
                onTap: () {
                  onTabConfirm();
                  Navigator.of(context).pop();
                },
                backgroundColor: BUTTON_COLOR,
              ),
            ),
          ],
        ),
      ],
      backgroundColor: PRIMARY_COLOR,
      surfaceTintColor: GRAY,
    );
  }
}
