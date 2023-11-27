import 'dart:convert';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import 'vo/spot.dart';

class ItemScreen extends StatefulWidget {
  final Spot spot;
  const ItemScreen({required this.spot, super.key});

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> with TickerProviderStateMixin {
  List<Widget> webcams = [];
  List<Widget> forecasts = [];
  List<Widget> reports = [];

  @override
  void initState() {
    super.initState();
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    loadWebcams();
  }

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void loadWebcams() async {
    final AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    animationListener() {}
    Animation? animation;

    webcams.clear();
    reports.clear();
    forecasts.clear();

    var response = await http.get(
        Uri.parse(
            "https://api.riedmann.rocks/windchecker/items/item?filter[spots][eq]=${widget.spot.id}"),
        headers: {"Accept": "application/json"});
    var dataOrig = json.decode(response.body)["data"];

    for (var el in dataOrig) {
      String imageUrl =
          el["url"] + "?dummy=" + Random().nextInt(1000000).toString();

      Widget view;
      switch (el["type"]) {
        case "image":
          view = getImageView(imageUrl);
          break;
        case "iframe":
          view = getWebView(imageUrl);
          break;
        default:
          view = getImageView(imageUrl);
      }

      if (el["art"] == "image") {
        webcams.add(view);
      }
      if (el["art"] == "forecast") {
        forecasts.add(view);
      }
      if (el["art"] == "report") {
        reports.add(view);
      }
    }

    setState(() {});
  }

  Widget getWebView(String url) {
    return Container(
        height: 400,
        color: Colors.grey,
        padding: const EdgeInsets.all(15),
        child: WebViewWidget(
          controller: getController(url),
        ));
  }

  WebViewController getController(String url) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(url));
  }

  Widget getImageView(String imageUrl) {
    Widget view = ExtendedImage.network(
      imageUrl,
      fit: BoxFit.fitHeight,
      cache: false,

      //enableLoadState: false,
      mode: ExtendedImageMode.gesture,

      initGestureConfigHandler: (state) {
        return GestureConfig(
          minScale: 1,
          animationMinScale: 0.7,
          maxScale: 3.0,
          animationMaxScale: 3.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: false,
          initialAlignment: InitialAlignment.center,
        );
      },
      onDoubleTap: (ExtendedImageGestureState state) {
        Navigator.pushNamed(context, '/image', arguments: imageUrl);
        return;
      },
    );
    return view;
  }

  List<Widget> getContent() {
    if (_selectedIndex == 0) {
      return webcams;
    } else if (_selectedIndex == 1) {
      return forecasts;
    } else {
      return reports;
    }
  }

  @override
  Widget build(BuildContext context) {
    //loadWebcams();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff346F5D),
          title: Text(widget.spot.name),
          actions: [
            IconButton(
                onPressed: () {
                  loadWebcams();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(child: Column(children: getContent())),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xff346F5D),
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Webcams',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Forecast',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Reports',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ));
  }
}
