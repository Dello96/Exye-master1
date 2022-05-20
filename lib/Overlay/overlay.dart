import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class PageOverlay extends StatefulWidget {
  const PageOverlay({Key? key}) : super(key: key);

  @override
  _PageOverlayState createState() => _PageOverlayState();
}

class _PageOverlayState extends State<PageOverlay> with TickerProviderStateMixin {
  Widget overlay = Container();
  int height = 0;
  late AnimationController overlayCont;
  late AnimationController contentCont;

  void load (Widget newOverlay, int newHeight) {
    setState(() {
      overlay = newOverlay;
      height = newHeight;
    });
  }

  @override
  void initState () {
    super.initState();
    overlayCont = AnimationController(vsync: this);
    contentCont = AnimationController(vsync: this);
    app.mOverlay.load = load;
    app.mOverlay.control = overlayCont;
    app.mOverlay.control2 = contentCont;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: buildCoverScreen(),
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: buildCoverScreen2(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: height + 40,
          child: buildContents(),
        ),
      ],
    );
  }

  Widget buildCoverScreen () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (overlayCont.value == 0) ? MediaQuery.of(context).size.height : 0, 0, 1,
          ),
          child: GestureDetector(
            onTap: () {
              //turn off overlay.
              //overlayCont.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.linear);
            },
            child: Opacity(
              opacity: overlayCont.value/2,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        color: app.mResource.colours.coverScreen,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildCoverScreen2 () {
    return AnimatedBuilder(
      animation: contentCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (contentCont.value == 0) ? MediaQuery.of(context).size.height : 0, 0, 1,
          ),
          child: GestureDetector(
            onTap: () {
              //turn off overlay.
              contentCont.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.linear);
            },
            child: Opacity(
              opacity: contentCont.value/2,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        color: app.mResource.colours.coverScreen,
      ),
    );
  }

  Widget buildContents () {
    return AnimatedBuilder(
      animation: contentCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (1-contentCont.value)*height + 40, 0, 1,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: (DragUpdateDetails details) {
              contentCont.animateTo((contentCont.value - details.delta.dy/height >= 0 && contentCont.value - details.delta.dy/height <= 1) ? contentCont.value - details.delta.dy/height : contentCont.value, duration: Duration(seconds: 0), curve: Curves.linear);
            },
            onVerticalDragEnd: (DragEndDetails details) {
              if (contentCont.value < 0.5) {
                contentCont.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.linear);
              }
              if (contentCont.value >= 0.5) {
                contentCont.animateTo(1, duration: const Duration(milliseconds: 200), curve: Curves.linear);
              }
            },
            onVerticalDragCancel: () {
              contentCont.animateTo(1, duration: const Duration(milliseconds: 200), curve: Curves.linear);
            },
            child: CustomBlurBox(
              child: Container(
                color: app.mResource.colours.semiBackground,
                height: height + 20,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: child!,
                    ),
                    Container(
                      height: 20,
                    ),
                    (height > 20) ? Container(
                      height: 20,
                    ) : Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: overlay,
    );
  }
}
