import 'package:flutter/material.dart';
import 'package:lotto_expert/layout/default_layout.dart';
import 'package:lotto_expert/screen/state_provider_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'HomeScreen',
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StateProviderScreen(),
              ));
            },
            child: Text('StateProviderScreen'),
          )
        ],
      ),
    );
  }
}
