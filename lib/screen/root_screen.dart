import 'package:flutter/material.dart';

import '../common/const/colors.dart';
import '../common/layout/default_layout.dart';
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
    return DefaultLayout(
      title: '로또 당첨 번호 통계',
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
          Container(
            child: Text('김종민'),
          ),
        ],
      ),
    );
  }
}
