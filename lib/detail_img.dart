import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class DetailImage extends StatefulWidget {
  String url;
  DetailImage({super.key, required this.url});

  @override
  State<DetailImage> createState() => _DetailImageState();
}

class _DetailImageState extends State<DetailImage>
    with TickerProviderStateMixin {
  String url = "";

  @override
  void initState() {
    super.initState();
    url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    final AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    animationListener() {}
    Animation? animation;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff346F5D),
        title: const Text(
          "Detail",
        ),
        actions: [
          IconButton(
              onPressed: () {
                int number = Random().nextInt(5000);
                setState(() {
                  url = "$url?$number";
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: getImage(),
    );
  }

  Widget getImage() {
    return InteractiveViewer(
        alignment: Alignment.bottomRight,
        minScale: 1,
        maxScale: 1.5,
        constrained: false,
        panEnabled: true,
        child: Image.network(url));
  }

  Widget getImage1(Animation<dynamic>? animation, Function() animationListener,
      AnimationController animationController) {
    return ExtendedImage.network(
      widget.url,
      fit: BoxFit.fitHeight,
      cache: false,
      height: 800,

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
        var pointerDownPosition = state.pointerDownPosition;
        double begin = state.gestureDetails!.totalScale!;
        double end;

        animation?.removeListener(animationListener);
        animationController.stop();
        animationController.reset();

        if (begin == 1) {
          end = 4;
        } else {
          end = 1;
        }
        animationListener = () {
          //print(_animation.value);
          state.handleDoubleTap(
              scale: animation!.value, doubleTapPosition: pointerDownPosition);
        };
        animation =
            animationController.drive(Tween<double>(begin: begin, end: end));

        animation!.addListener(animationListener);

        animationController.forward();
      },
    );
  }
}
