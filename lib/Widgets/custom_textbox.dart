import 'dart:ui';

import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final String header;
  final String text;
  final double height;
  final double width;
  const CustomTextBox({required this.header, required this.text, required this.height, required this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      //height: height,
      width: width,
      decoration: BoxDecoration(
        color: app.mResource.colours.textBoxBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: app.mResource.colours.textBoxBorder, width: 2),
        boxShadow: [BoxShadow(
          color: app.mResource.colours.boxShadow,
          blurRadius: 4,
          offset: Offset(2, 2),
        )],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: app.mResource.fonts.header,),
          Container(height: 10,),
          Text(text, style: app.mResource.fonts.landing),
        ],
      ),
    );
  }
}

class CustomBox extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  const CustomBox({required this.child, this.height, this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: app.mResource.colours.textBoxBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: app.mResource.colours.textBoxBorder, width: 2),
        boxShadow: [BoxShadow(
          color: app.mResource.colours.boxShadow,
          blurRadius: 4,
          offset: const Offset(2, 2),
        )],
      ),
      child: child,
    );
  }
}

class CustomBlurBox extends StatelessWidget {
  final Widget child;
  const CustomBlurBox({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3.0,
          sigmaY: 3.0,
        ),
        child: child,
      ),
    );
  }
}

