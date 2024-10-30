import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lotto_expert/riverpod/isar_provider.dart';
import 'package:lotto_expert/screen/root_screen.dart';

void main() async {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IsarInitializer(),
      ),
    ),
  );
}

class IsarInitializer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarAsyncValue = ref.watch(isarProvider);
    return isarAsyncValue.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      data: (isar) => RootScreen(),
    );
  }
}
