import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/screen/root_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: RootScreen(),
      ),
    ),
  );
}
