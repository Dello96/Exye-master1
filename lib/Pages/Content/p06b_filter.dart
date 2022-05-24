import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:exye_app/Pages/Content/p01_signup.dart';
import 'package:exye_app/Pages/Content/p02_login.dart';
import 'package:exye_app/Pages/Content/p03_terms.dart';
import 'package:exye_app/Pages/Content/p03a_policy.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_divider.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exye_app/Data/categoryname.dart';

class FilterOverlay extends StatefulWidget {
  const FilterOverlay({Key? key}) : super(key: key);

  @override
  State<FilterOverlay> createState() => _FilterOverlayState();
}

class _FilterOverlayState extends State<FilterOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.topLeft,
            child: Text(app.mResource.strings.cFilterTitle,
            style: app.mResource.fonts.bold14),
          ),
          Container(
            height: 15,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.lGender,
                      style: app.mResource.fonts.filter12),
                    ),
                    CustomSizedDivider(45, thickness: 1),
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                        color: app.mResource.colours.black,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.lFemale,
                      style: app.mResource.fonts.filter13),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: app.mResource.colours.black,
                          width: 1
                        )
                      ),
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.lMale,
                          style: app.mResource.fonts.filter12
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.lProducts,
                          style: app.mResource.fonts.filter12),
                    ),
                    CustomSizedDivider(45, thickness: 1),
                    Container( //의류
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                          color: app.mResource.colours.black,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.cFilterClothes,
                        style: app.mResource.fonts.filter13),
                    ),
                    MyCustomWidget(touch: () {
                      setState(() {
                      });
                    })
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(app.mResource.strings.lStyle,
                            style: app.mResource.fonts.filter12),
                      ),
                      CustomSizedDivider(240, thickness: 1),
                      Expanded(child: CategoryView())
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: 150,
              height: 50,
              decoration: BoxDecoration(
                color: app.mResource.colours.black,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 1
                )
              ),
              child: Text(app.mResource.strings.bConfirmChoices2,
              style: app.mResource.fonts.bold14w
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMiniButton extends StatefulWidget {
  bool active;
  CustomMiniButton({this.active = true, Key? key}) : super(key: key);

  @override
  State<CustomMiniButton> createState() => _CustomMiniButtonState();
}

class _CustomMiniButtonState extends State<CustomMiniButton> {
  bool _pressed2 = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.active) {
          setState(
              () {
                _pressed2 = true;
              }
          );
        }
      },
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          width: 150,
          height: 50,
          decoration: BoxDecoration(
              color: app.mResource.colours.black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  width: 1
              )
          ),
          child: Text(app.mResource.strings.bConfirmChoices2,
              style: app.mResource.fonts.bold14w
          ),
        ),
      ),
    );
  }
}


class CategoryView extends StatefulWidget {
  CategoryView({Key? key}) : super(key: key);
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 11/4,
        ),
        itemBuilder: (BuildContext context, int i) {
          return Center(
            child: Container(
              height: 40,
              width: 110,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        app.mResource.colours.activeDateUnpressed,
                        Color(0xffB2D1EA)
                      ]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: app.mResource.colours.black,
                      width: 1
                  )
              ),
              alignment: Alignment.center,
              child: Text(app.mCategory.categories[i],
                  style: app.mResource.fonts.filter12),
            ),
          );
        },
        itemCount: app.mCategory.categories.length);
  }
}
