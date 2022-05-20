import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpostal/kpostal.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController control;
  final String text;
  final FocusNode node;
  final int index;
  final int maxLength;
  final Function fullFunction;
  const CustomTextField({required this.control, required this.text, required this.node, required this.index, required this.maxLength, required this.fullFunction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: app.mResource.colours.textBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: control,
            focusNode: node,
            autofocus: true,
            keyboardType: TextInputType.number,
            style: app.mResource.fonts.base,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.fromLTRB(85, 10, 10, 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: text,
              hintStyle: app.mResource.fonts.inactive,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (String value) async {
              if (control.text.length == maxLength) {
                app.mApp.input.setText(value, index: index);
                await fullFunction();
              }
            },
            onTap: () {
              app.mApp.input.setActive(index);
            },
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          width: 20,
          child: Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Image.asset(app.mResource.images.koreanFlag),
              ),
            ),
          ),
        ),
        Positioned(
          left: 40,
          top: 0,
          bottom: 0,
          width: 40,
          child: Container(
            alignment: Alignment.center,
            height: 15,
            child: Text("+82", style: app.mResource.fonts.base),
          ),
        ),
        Positioned(
          right: 10,
          top: 5,
          bottom: 5,
          width: 25,
          child: Container(
            alignment: Alignment.centerRight,
            child: CustomImageButton(
              image: app.mResource.images.bExit,
              height: 24,
              width: 24,
              function: () {
                control.clear();
              },
              colourPressed: app.mResource.colours.transparent,
              colourUnpressed: app.mResource.colours.transparent,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPasswordInput extends StatefulWidget {
  final int inputNo;
  const CustomPasswordInput(this.inputNo, {Key? key}) : super(key: key);

  @override
  _CustomPasswordInputState createState() => _CustomPasswordInputState();
}

class _CustomPasswordInputState extends State<CustomPasswordInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildDigit(0),
          buildDigit(1),
          buildDigit(2),
          buildDigit(3),
          buildDigit(4),
          buildDigit(5),
        ],
      ),
    );
  }

  Widget buildDigit (int index) {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      child: (app.mApp.input.texts[widget.inputNo].length > index) ?  ((app.mApp.input.show) ? buildText(index) : buildShape(index, false)) : buildShape(index, true),
    );
  }

  Widget buildText (int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: 30,
      height: 30,
      alignment: Alignment.center,
      child: Text(app.mApp.input.texts[widget.inputNo].substring(index, index + 1), style: app.mResource.fonts.keyboardPassword,),
    );
  }

  Widget buildShape (int index, bool empty) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: 20,
      height: 20,
      alignment: Alignment.center,
      child: Icon(
        Icons.circle,
        size: 20,
        color: empty ? app.mResource.colours.passwordEmpty : app.mResource.colours.passwordFilled,
      ),
    );
  }
}

class CustomAddressField extends StatelessWidget {
  final TextEditingController control;
  final String text;
  final FocusNode node;
  final int index;
  const CustomAddressField({required this.control, required this.text, required this.node, required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: app.mResource.colours.textBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: control,
            focusNode: node,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: text,
              hintStyle: app.mResource.fonts.inactive,
            ),
            onTap: () {
              app.mApp.input.setActive(index);
            },
          ),
        ),
        Positioned(
          right: 10,
          top: 5,
          bottom: 5,
          width: 25,
          child: Container(
            alignment: Alignment.centerRight,
            child: CustomImageButton(
              image: app.mResource.images.bExit,
              height: 24,
              width: 24,
              function: () {
                app.mApp.input.clear(index: index);
              },
              colourPressed: app.mResource.colours.transparent,
              colourUnpressed: app.mResource.colours.transparent,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomAddressSearch extends StatelessWidget {
  final TextEditingController control;
  final String text;
  final int index;
  const CustomAddressSearch({required this.control, required this.text, required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: app.mResource.colours.textBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: control,
            keyboardType: TextInputType.none,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: text,
              hintStyle: app.mResource.fonts.inactive,
            ),
            onChanged: (value) {
              app.mApp.input.setText(value, index: index);
            },
            onTap: () async {
              app.mPage.nextPage(KpostalView(
                callback: (Kpostal result) async {
                  app.mApp.input.setActive(-1);
                  app.mApp.node.unfocus();
                  for (int i = 0; i < app.mResource.strings.postCodeLow.length; i++) {
                    if (int.parse(result.postCode) >= app.mResource.strings.postCodeLow[i] && int.parse(result.postCode) <= app.mResource.strings.postCodeHigh[i]) {
                      app.mApp.input.setText(result.address, index: index);
                      return;
                    }
                  }
                  //app.mPage.prevPage();
                  app.mApp.input.setText(result.address, index: index);
                  //await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aInvalidAddress, text: app.mResource.strings.eInvalidAddress);
                },
              ));
            },
          ),
        ),
        Positioned(
          right: 10,
          top: 5,
          bottom: 5,
          width: 25,
          child: Container(
            alignment: Alignment.centerRight,
            child: CustomImageButton(
              image: app.mResource.images.bExit,
              height: 24,
              width: 24,
              function: () {
                app.mApp.input.clear(index: index);
              },
              colourPressed: app.mResource.colours.transparent,
              colourUnpressed: app.mResource.colours.transparent,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomNumberField extends StatelessWidget {
  final TextEditingController control;
  final String text;
  final FocusNode node;
  final int index;
  const CustomNumberField({required this.control, required this.text, required this.node, required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: app.mResource.colours.textBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: control,
            focusNode: node,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: text,
              hintStyle: app.mResource.fonts.inactive,
            ),
            onChanged: (value) {
              app.mApp.input.setText(value, index: index);
            },
            onTap: () {
              app.mApp.input.setActive(index);
            },
          ),
        ),
        Positioned(
          right: 10,
          top: 5,
          bottom: 5,
          width: 25,
          child: Container(
            alignment: Alignment.centerRight,
            child: CustomImageButton(
              image: app.mResource.images.bExit,
              height: 24,
              width: 24,
              function: () {
                app.mApp.input.clear(index: index);
              },
              colourPressed: app.mResource.colours.transparent,
              colourUnpressed: app.mResource.colours.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
