import 'package:flutter/material.dart';
import 'package:windchecker/detail_img.dart';

import 'package:windchecker/spot_screen.dart';
import 'package:windchecker/vo/spot.dart';

import 'item_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (context) => const SpotScreen());

          case "/items":
            Spot spot = settings.arguments as Spot;
            return MaterialPageRoute(
                builder: (context) => ItemScreen(
                      spot: spot,
                    ));
          case "/image":
            String url = settings.arguments as String;
            return MaterialPageRoute(
                builder: (context) => DetailImage(url: url));

          default:
        }
        return null;
      },
      /*routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const SpotScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/items': (context) => const ItemScreen(),
      },*/
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          onSurface: Colors.white,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}
