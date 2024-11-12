import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotto_expert/screen/record_screen.dart';
import '../bloc/home_bloc.dart';
import '../common/const/colors.dart';
import '../common/layout/default_layout.dart';
import '../repository/isar_repository.dart';
import '../repository/lotto_repository.dart';
import 'home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(
            lottoRepository: context.read<LottoRepository>(),
            isarRepository: context.read<IsarRepository>(),
          ),
        ),
      ],
      child: DefaultLayout(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: PRIMARY_COLOR,
          selectedItemColor: PRIMARY_BLACK,
          unselectedItemColor: SECONDARY_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            controller.animateTo(index);
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: '검색',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              label: '기록',
            ),
          ],
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            HomeScreen(),
            RecordScreen(),
          ],
        ),
      ),
    );
  }
}
