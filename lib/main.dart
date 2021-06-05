import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'loading.dart';
import 'content.dart';
import 'welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  Paint.enableDithering = true;
  runApp(MaterialApp(
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => Loading(),
        '/content': (context) => MainPage(),
        '/welcome': (context) => WelcomePage(),
      },
    )
  );
}

