import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class CustomBrandsSurvey extends StatefulWidget {
  final CustomBrandsState state;
  const CustomBrandsSurvey(this.state, {Key? key}) : super(key: key);

  @override
  _CustomBrandsSurveyState createState() => _CustomBrandsSurveyState();
}

class _CustomBrandsSurveyState extends State<CustomBrandsSurvey> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: app.mResource.strings.brandsList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: CustomBox(
              height: 75,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    width: 70,
                    alignment: Alignment.center,
                    child: Image.asset(app.mResource.images.brandsList[index], width: 70, height: 70,),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(app.mResource.strings.brandsList[index], style: app.mResource.fonts.bold,),
                        Text(app.mResource.strings.brandsListKorean[index], style: app.mResource.fonts.bold,),
                      ],
                    ),
                  ),
                  CustomImageToggle(
                    key: UniqueKey(),
                    image: app.mResource.images.bCheckEmpty,
                    imagePressed: app.mResource.images.bCheckFilled,
                    height: 50,
                    width: 50,
                    function: () {
                      widget.state.choices[index] = !widget.state.choices[index];
                      setState(() {});
                    },
                    initial: widget.state.choices[index],
                    colourUnpressed: app.mResource.colours.transparent,
                    colourPressed: app.mResource.colours.black,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomBrandsState {
  List<bool> choices = [
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
    false, false, false, false,
    false,
  ];
}
