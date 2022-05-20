import 'package:exye_app/Overlay/overlay.dart';
import 'package:flutter/cupertino.dart';

class OverlayManager {
  PageOverlay? overlayObj;
  Function? load;
  AnimationController? control;
  AnimationController? control2;

  void initialise () {
    overlayObj ??= const PageOverlay();
  }

  void loadOverlay (Widget overlay, int height) {
    load!(overlay, height);
  }

  Future<void> overlayOn () async {
    await control!.animateTo(1, duration: const Duration(milliseconds: 0), curve: Curves.linear);
  }

  Future<void> overlayOff () async {
    await control!.animateTo(0, duration: const Duration(milliseconds: 0), curve: Curves.linear);
  }

  Future<void> panelOn () async {
    await control2!.animateTo(1, duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  Future<void> panelOff () async {
    await control2!.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

}