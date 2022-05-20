import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class CustomPageViewElement extends StatelessWidget {
  final Widget child;
  const CustomPageViewElement({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
        app.mApp.input.setActive(-1);
      },
      child: child,
    );
  }
}

class CustomPageViewElementPassword extends StatelessWidget {
  final Widget child;
  const CustomPageViewElementPassword({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        //do nothing
      },
      child: child,
    );
  }
}