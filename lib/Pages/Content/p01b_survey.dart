import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_textfield.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class CustomSurvey extends StatefulWidget {
  final CustomSurveyState state;
  const CustomSurvey(this.state, {Key? key}) : super(key: key);

  @override
  _CustomSurveyState createState() => _CustomSurveyState();
}

class _CustomSurveyState extends State<CustomSurvey> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 75,
                alignment: Alignment.centerLeft,
                child: Text(app.mResource.strings.lName, style: app.mResource.fonts.header,),
              ),
              Expanded(
                child: CustomAddressField(
                  control: app.mApp.input.controls[0],
                  node: app.mApp.node,
                  index: 0,
                  text: app.mResource.strings.iName,
                ),
              ),
            ],
          ),
          Container(
            height: 20,
          ),
          buildGenderChoices(),
          Container(
            height: 20,
          ),
          buildAgeChoices(),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget buildGenderChoices () {
    return Row(
      children: [
        Container(
          width: 75,
          alignment: Alignment.centerLeft,
          child: Text(app.mResource.strings.lGender, style: app.mResource.fonts.header,),
        ),
        CustomTextToggle(
          key: UniqueKey(),
          text: app.mResource.strings.lMale,
          style: app.mResource.fonts.bold16,
          function: () {
            setState(() {
              FocusScope.of(context).unfocus();
              widget.state.gender = "Male";
            });
          },
          height: 50,
          width: 90,
          initial: (widget.state.gender == "Male"),
        ),
        Expanded(
          child: Container(),
        ),
        CustomTextToggle(
          key: UniqueKey(),
          text: app.mResource.strings.lFemale,
          style: app.mResource.fonts.bold16,
          function: () {
            setState(() {
              FocusScope.of(context).unfocus();
              widget.state.gender = "Female";
            });
          },
          height: 50,
          width: 90,
          initial: (widget.state.gender == "Female"),
        ),
      ],
    );
  }

  Widget buildAgeChoices () {
    return Row(
      children: [
        Container(
          width: 75,
          alignment: Alignment.centerLeft,
          child: Text(app.mResource.strings.lAge, style: app.mResource.fonts.header,),
        ),
        CustomTextToggle(
          key: UniqueKey(),
          text: app.mResource.strings.lAge0,
          style: app.mResource.fonts.bold16,
          function: () {
            setState(() {
              FocusScope.of(context).unfocus();
              widget.state.age = 0;
            });
          },
          height: 50,
          width: 50,
          initial: (widget.state.age == 0),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        CustomTextToggle(
          key: UniqueKey(),
          text: app.mResource.strings.lAge1,
          style: app.mResource.fonts.bold16,
          function: () {
            setState(() {
              FocusScope.of(context).unfocus();
              widget.state.age = 1;
            });
          },
          height: 50,
          width: 50,
          initial: (widget.state.age == 1),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        CustomTextToggle(
          key: UniqueKey(),
          text: app.mResource.strings.lAge2,
          style: app.mResource.fonts.bold16,
          function: () {
            setState(() {
              FocusScope.of(context).unfocus();
              widget.state.age = 2;
            });
          },
          height: 50,
          width: 50,
          initial: (widget.state.age == 2),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        CustomTextToggle(
          key: UniqueKey(),
          text: app.mResource.strings.lAge3,
          style: app.mResource.fonts.bold16,
          function: () {
            setState(() {
              FocusScope.of(context).unfocus();
              widget.state.age = 3;
            });
          },
          height: 50,
          width: 50,
          initial: (widget.state.age == 3),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        CustomTextToggle(
          key: UniqueKey(),
          text: app.mResource.strings.lAge4,
          style: app.mResource.fonts.bold16,
          function: () {
            setState(() {
              FocusScope.of(context).unfocus();
              widget.state.age = 4;
            });
          },
          height: 50,
          width: 50,
          initial: (widget.state.age == 4),
        ),
      ],
    );
  }
}

class CustomAddressSurvey extends StatefulWidget {
  final CustomSurveyState state;
  const CustomAddressSurvey(this.state, {Key? key}) : super(key: key);

  @override
  _CustomAddressSurveyState createState() => _CustomAddressSurveyState();
}

class _CustomAddressSurveyState extends State<CustomAddressSurvey> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 75,
                alignment: Alignment.centerLeft,
                child: Text(app.mResource.strings.lAddress, style: app.mResource.fonts.header,),
              ),
              Expanded(
                child: CustomAddressSearch(
                  control: app.mApp.input.controls[1],
                  index: 1,
                  text: app.mResource.strings.iAddress,
                ),
              ),
            ],
          ),
          Container(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 75,
                alignment: Alignment.centerLeft,
                child: Text(app.mResource.strings.lAddressDetails, style: app.mResource.fonts.header,),
              ),
              Expanded(
                child: CustomAddressField(
                  control: app.mApp.input.controls[2],
                  node: app.mApp.node,
                  index: 2,
                  text: app.mResource.strings.iAddressDetails,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomBodySurvey extends StatefulWidget {
  final CustomSurveyState state;
  const CustomBodySurvey(this.state, {Key? key}) : super(key: key);

  @override
  _CustomBodySurveyState createState() => _CustomBodySurveyState();
}

class _CustomBodySurveyState extends State<CustomBodySurvey> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: app.mResource.strings.lHeight, style: app.mResource.fonts.header,),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    CustomNumberField(
                      control: app.mApp.input.controls[1],
                      index: 1,
                      node: app.mApp.node,
                      text: app.mResource.strings.iHeight,
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 40,
                      width: 30,
                      child: Container(
                        height: 50,
                        width: 30,
                        alignment: Alignment.center,
                        child: Text("cm", style: app.mResource.fonts.bold,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 80,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: app.mResource.strings.lWeight, style: app.mResource.fonts.header,),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    CustomNumberField(
                      control: app.mApp.input.controls[2],
                      node: app.mApp.node2,
                      index: 2,
                      text: app.mResource.strings.iWeight,
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 30,
                      width: 40,
                      child: Container(
                        height: 50,
                        width: 30,
                        alignment: Alignment.center,
                        child: Text("kg", style: app.mResource.fonts.bold,),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}


class CustomSurveyState {
  String name = "";
  String gender = "";
  int age = -1;

  String address = "";
  String addressDetails = "";

  int height = 0;
  int weight = 0;
}
