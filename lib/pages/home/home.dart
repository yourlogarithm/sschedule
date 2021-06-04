import 'package:flutter/material.dart';
import 'homeHeader.dart';
import 'homeBody.dart';

class Home extends StatelessWidget {
  // const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        HomeHeader(),
        HomeBody()
      ],
    );
  }
}
