import 'package:flutter/material.dart';
import 'loading.dart';
import 'content.dart';
import 'welcome.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MaterialApp(
    initialRoute: '/loading',
    routes: {
      '/loading': (context) => Loading(),
      '/content': (context) => MainPage(),
      '/welcome': (context) => WelcomePage(),
    },
  ));
}

