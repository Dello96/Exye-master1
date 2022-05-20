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

class FilterOverlay extends StatelessWidget {
  const FilterOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(app.mResource.strings.cFilterTitle,
            style: app.mResource.fonts.bold14),
          ),
          Container(
            height: 10,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.lGender),
                    ),
                    CustomSizedDivider(40, thickness: 2),
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
                      style: TextStyle(
                        color: app.mResource.colours.fontWhite
                      ),),
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
                      child: Text(app.mResource.strings.lMale),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.lProducts),
                    ),
                    CustomSizedDivider(40, thickness: 2),
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
                        style: TextStyle(
                          color: app.mResource.colours.fontWhite
                        ),),
                    ),
                    Container( //가방
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
                      child: Text(app.mResource.strings.cFilterBag),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(app.mResource.strings.lStyle),
                    ),
                    CustomSizedDivider(200, thickness: 2),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: app.mResource.colours.black
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                alignment: Alignment.center,
                                child: Text(app.mResource.strings.cFiltertop),
                              ),
                              Container(
                                height: 40,
                                width: 120,
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: app.mResource.colours.black,
                                        width: 1
                                    )
                                ),
                                alignment: Alignment.center,
                                child: Text(app.mResource.strings.cFilterpolo),
                              ),
                              Container(
                                height: 40,
                                width: 120,
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: app.mResource.colours.black,
                                        width: 1
                                    )
                                ),
                                alignment: Alignment.center,
                                child: Text(app.mResource.strings.cFilterknit),
                              ),
                              Container(
                                height: 40,
                                width: 120,
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: app.mResource.colours.black,
                                        width: 1
                                    )
                                ),
                                alignment: Alignment.center,
                                child: Text(app.mResource.strings.cFilterjacket),
                              ),
                              Container(
                                height: 40,
                                width: 120,
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: app.mResource.colours.black,
                                        width: 1
                                    )
                                ),
                                alignment: Alignment.center,
                                child: Text(app.mResource.strings.cFiltervest),
                              ),
                              Container(
                                height: 40,
                                width: 120,
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: app.mResource.colours.black,
                                        width: 1
                                    )
                                ),
                                alignment: Alignment.center,
                                child: Text(app.mResource.strings.cFiltershirt),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(),
                            Container(),
                            Container(),
                            Container(),
                            Container(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 400,
            height: 50,
            color: Colors.black,
            child: Text(app.mResource.strings.bConfirmChoices2),
          ),
        ],
      ),
    );
  }
}
