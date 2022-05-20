import 'dart:async';

import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double? width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  const CustomTextButton({
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    Key? key}) : super(key: key);

  @override
  _CustomTextButtonState createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          await app.mOverlay.overlayOn();
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
          await app.mOverlay.overlayOff();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return UnconstrainedBox(
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: widget.active ? app.mResource.colours.buttonBorder : app.mResource.colours.buttonInactive, width: 1),
        ),
        child: Center(
          child: Text(widget.text, style: widget.active ? widget.style : app.mResource.fonts.inactive,),
        ),
      ),
    );
  }
}

class CustomTextButton2 extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double? width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  const CustomTextButton2({
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    Key? key}) : super(key: key);

  @override
  _CustomTextButton2State createState() => _CustomTextButton2State();
}

class _CustomTextButton2State extends State<CustomTextButton2> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return UnconstrainedBox(
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: widget.active ? app.mResource.colours.buttonBorder : app.mResource.colours.buttonInactive, width: 1),
        ),
        child: Center(
          child: Text(widget.text, style: widget.active ? widget.style : app.mResource.fonts.inactive,),
        ),
      ),
    );
  }
}

class CustomTextButtonNoPadding extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  const CustomTextButtonNoPadding({
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    required this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    Key? key}) : super(key: key);

  @override
  _CustomTextButtonNoPaddingState createState() => _CustomTextButtonNoPaddingState();
}

class _CustomTextButtonNoPaddingState extends State<CustomTextButtonNoPadding> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          await app.mOverlay.overlayOn();
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
          await app.mOverlay.overlayOff();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return UnconstrainedBox(
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: widget.active ? app.mResource.colours.buttonBorder : app.mResource.colours.buttonInactive, width: 1),
        ),
        child: Center(
          child: Text(widget.text, style: widget.active ? widget.style : app.mResource.fonts.inactive,),
        ),
      ),
    );
  }
}

class CustomImageButton extends StatefulWidget {
  final String image;
  final Function function;
  final double height;
  final double width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  final double thickness;
  const CustomImageButton({
    required this.image,
    required this.function,
    required this.height,
    required this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    this.thickness = 1,
    Key? key}) : super(key: key);

  @override
  _CustomImageButtonState createState() => _CustomImageButtonState();
}

class _CustomImageButtonState extends State<CustomImageButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          await app.mOverlay.overlayOn();
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
          await app.mOverlay.overlayOff();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
        borderRadius: BorderRadius.circular(widget.height / 2),
        border: Border.all(color: widget.active ? app.mResource.colours.buttonBorder : app.mResource.colours.buttonInactive, width: widget.thickness),
      ),
      child: SizedBox(
        height: widget.height - (widget.height * 0.3),
        width: widget.width - (widget.width * 0.3),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(widget.image),
        ),
      ),
    );
  }
}

class CustomHybridButton extends StatefulWidget {
  final String image;
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double? width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  const CustomHybridButton({
    required this.image,
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    Key? key}) : super(key: key);

  @override
  _CustomHybridButtonState createState() => _CustomHybridButtonState();
}

class _CustomHybridButtonState extends State<CustomHybridButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          await app.mOverlay.overlayOn();
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
          await app.mOverlay.overlayOff();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: widget.active ? app.mResource.colours.buttonBorder : app.mResource.colours.buttonInactive, width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                height: 20,
                width: 20,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset(widget.image),
                ),
              ),
              Text(widget.text, style: widget.active ? widget.style : app.mResource.fonts.inactive,),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomHybridButton2 extends StatefulWidget {
  final String image;
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double? width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  const CustomHybridButton2({
    required this.image,
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    Key? key}) : super(key: key);

  @override
  _CustomHybridButton2State createState() => _CustomHybridButton2State();
}

class _CustomHybridButton2State extends State<CustomHybridButton2> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          await app.mOverlay.overlayOn();
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
          await app.mOverlay.overlayOff();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: widget.active ? app.mResource.colours.buttonBorder : app.mResource.colours.buttonInactive, width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.text, style: widget.active ? widget.style : app.mResource.fonts.inactive,),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                height: 20,
                width: 20,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset(widget.image),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomHybridButton3 extends StatefulWidget {
  final String image;
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double? width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  const CustomHybridButton3({
    required this.image,
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    Key? key}) : super(key: key);

  @override
  _CustomHybridButton3State createState() => _CustomHybridButton3State();
}

class _CustomHybridButton3State extends State<CustomHybridButton3> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          await app.mOverlay.overlayOn();
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
          await app.mOverlay.overlayOff();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(color: widget.active ? app.mResource.colours.buttonBorder : app.mResource.colours.buttonInactive, width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                height: 15,
                width: 48,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset(widget.image),
                ),
              ),
              Text(widget.text, style: widget.active ? widget.style : app.mResource.fonts.inactive,),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextToggle extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  final bool initial;
  const CustomTextToggle({
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    required this.width,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    this.initial = false,
    Key? key}) : super(key: key);

  @override
  _CustomTextToggleState createState() => _CustomTextToggleState();
}

class _CustomTextToggleState extends State<CustomTextToggle> {
  late bool _pressed;

  @override
  void initState () {
    super.initState();
    _pressed = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          setState(() {
            _pressed = !_pressed;
          });
          await widget.function();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _pressed ? (widget.colourPressed ?? app.mResource.colours.black) : (widget.colourUnpressed ?? app.mResource.colours.buttonLight),
        borderRadius: BorderRadius.circular(widget.height / 2),
        border: Border.all(color: app.mResource.colours.buttonBorder, width: 1),
      ),
      child: Text(widget.text, style: _pressed ? app.mResource.fonts.bWhite : widget.style,)
    );
  }
}

class CustomImageToggle extends StatefulWidget {
  final String image;
  final String? imagePressed;
  final Function function;
  final double height;
  final double width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  final bool active;
  final bool initial;
  const CustomImageToggle({
    required this.image,
    required this.function,
    required this.height,
    required this.width,
    this.imagePressed,
    this.colourPressed,
    this.colourUnpressed,
    this.active = true,
    this.initial = false,
    Key? key}) : super(key: key);

  @override
  _CustomImageToggleState createState() => _CustomImageToggleState();
}

class _CustomImageToggleState extends State<CustomImageToggle> {
  late bool _pressed;

  @override
  void initState () {
    super.initState();
    _pressed = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.active) {
          setState(() {
            _pressed = !_pressed;
          });
          await widget.function();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
        borderRadius: BorderRadius.circular(widget.height / 2),
        border: Border.all(color: app.mResource.colours.buttonBorder, width: 1),
      ),
      child: _pressed ? (Image.asset(widget.imagePressed ?? widget.image, width: widget.width - (widget.width * 0.3), height: widget.height - (widget.height * 0.3),)) : Image.asset(widget.image, width: widget.width - (widget.width * 0.3), height: widget.height - (widget.height * 0.3),),
    );
  }
}

class CustomKeyboardTextButton extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function function;
  final double height;
  final double width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  const CustomKeyboardTextButton({
    required this.text,
    required this.style,
    required this.function,
    required this.height,
    required this.width,
    this.colourPressed,
    this.colourUnpressed,
    Key? key}) : super(key: key);

  @override
  _CustomKeyboardTextButtonState createState() => _CustomKeyboardTextButtonState();
}

class _CustomKeyboardTextButtonState extends State<CustomKeyboardTextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (app.mApp.input.active != -1) {
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return Container(
      height: widget.height,
      width: widget.width,
      color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
      child: Center(
        child: Text(widget.text, style: widget.style,),
      ),
    );
  }
}

class CustomKeyboardBackButton extends StatefulWidget {
  final String image;
  final Function function;
  final double height;
  final double width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  const CustomKeyboardBackButton({
    required this.image,
    required this.function,
    required this.height,
    required this.width,
    this.colourPressed,
    this.colourUnpressed,
    Key? key}) : super(key: key);

  @override
  _CustomKeyboardBackButtonState createState() => _CustomKeyboardBackButtonState();
}

class _CustomKeyboardBackButtonState extends State<CustomKeyboardBackButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (app.mApp.input.active != -1) {
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return Container(
      height: widget.height,
      width: widget.width,
      color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
      child: Center(
        child: Image.asset(widget.image, width: 25, height: 25,),
      ),
    );
  }
}

class CustomKeyboardExitButton extends StatefulWidget {
  final String image;
  final Function function;
  final double height;
  final double width;
  final Color? colourPressed;
  final Color? colourUnpressed;
  const CustomKeyboardExitButton({
    required this.image,
    required this.function,
    required this.height,
    required this.width,
    this.colourPressed,
    this.colourUnpressed,
    Key? key}) : super(key: key);

  @override
  _CustomKeyboardExitButtonState createState() => _CustomKeyboardExitButtonState();
}

class _CustomKeyboardExitButtonState extends State<CustomKeyboardExitButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (app.mApp.input.active != -1) {
          setState(() {
            _pressed = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _pressed = false;
          });
          await widget.function();
        }
      },
      child: buildButton(),
    );
  }

  Widget buildButton () {
    return Container(
      height: widget.height,
      width: widget.width,
      color: _pressed ? (widget.colourPressed ?? app.mResource.colours.buttonPressed) : (widget.colourUnpressed ?? app.mResource.colours.buttonUnpressed),
      child: Center(
        child: Image.asset(widget.image, width: 25, height: 25,),
      ),
    );
  }
}