import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:exye_app/Pages/Content/p03_terms.dart';
import 'package:exye_app/Pages/Content/p03a_policy.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> with SingleTickerProviderStateMixin {
  final PageController control = PageController();
  late AnimationController animator;

  void listen () {
    animator.animateTo(control.position.activity!.velocity, duration: const Duration(seconds: 0), curve: Curves.linear);
  }

  @override
  void initState () {
    super.initState();
    control.addListener(listen);
    animator = AnimationController.unbounded(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildPageList(context),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 70,
          child: buildButtons(),
        ),
      ],
    );
  }

  Widget buildPageList (BuildContext context) {
    return PageView.builder(
      controller: control,
      physics: const ClampingScrollPhysics(parent: BouncingScrollPhysics()),
      scrollDirection: Axis.vertical,
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            buildBackground(index),
            Center(
              child: buildPage(index),
            ),
          ],
        );
      },
    );
  }

  Widget buildButtons () {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: app.mResource.colours.whiteClear,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomImageButton(
            image: app.mResource.images.bExit,
            height: 50,
            width: 50,
            function: () {
              app.mPage.prevPage();
            },
            colourPressed: app.mResource.colours.buttonLight,
            colourUnpressed: app.mResource.colours.buttonLight,
          ),
          CustomHybridButton(
            image: app.mResource.images.bCall,
            text: app.mResource.strings.bCall,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () async {
              await app.mApp.call();
              //app.mPage.prevPage();
            },
            colourPressed: app.mResource.colours.buttonLight,
            colourUnpressed: app.mResource.colours.buttonLight,
          ),
          CustomHybridButton(
            image: app.mResource.images.bKakao,
            text: app.mResource.strings.bKakao,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () async {
              await launch(app.mData.kakaoLink);
              //app.mPage.prevPage();
            },
            colourPressed: app.mResource.colours.buttonLight,
            colourUnpressed: app.mResource.colours.buttonLight,
          ),
        ],
      ),
    );
  }

  Widget buildBackground (int index) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.asset(app.mResource.images.landingBackground[index]),
      ),
    );
  }

  Widget buildPage (int index) {
    return AnimatedBuilder(
      animation: animator,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, atan(animator.value / 200) * 40, 0, 1,
          ),
          child: child,
        );
      },
      child: buildPageContent(index),
    );
  }

  Widget buildPageContent (int index) {
    if (index == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(40, 20, 40, 5),
            child: Container(
              alignment: Alignment.center,
              height: 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(app.mResource.images.logoLarge),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding1H1,
            text: app.mResource.strings.tLanding1P1,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Container(
            height: 14,
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding1H2,
            text: app.mResource.strings.tLanding1P2,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Container(
            height: 14,
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding1H3,
            text: app.mResource.strings.tLanding1P3,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Container(
            height: 14,
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding3H1,
            text: app.mResource.strings.tLanding3P1,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Expanded(
            child: Container(),
          ),
          const SizedBox(
            height: 70,
          ),
        ],
      );
    }
    if (index == 1) {
      double columnWidth = MediaQuery.of(context).size.width / 2;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(40, 20, 40, 10),
            child: Text(app.mResource.strings.tLanding2Title, style: app.mResource.fonts.title,),
          ),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
              ),
              SizedBox(
                width: columnWidth - 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextBox(
                      header: app.mResource.strings.tLanding2H1,
                      text: app.mResource.strings.tLanding2P1,
                      height: 80,
                      width: columnWidth - 40,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: columnWidth - 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextBox(
                      header: app.mResource.strings.tLanding2H2,
                      text: app.mResource.strings.tLanding2P2,
                      height: 80,
                      width: columnWidth - 40,
                    ),
                    Container(
                      height: 10,
                    ),
                    CustomTextBox(
                      header: app.mResource.strings.tLanding2H4,
                      text: app.mResource.strings.tLanding2P4,
                      height: 80,
                      width: columnWidth - 40,
                    ),
                  ],
                ),
              ),
              Container(
                width: 20,
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: 70,
          ),
        ],
      );
    }
    if (index == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(40, 10, 40, 5),
            child: Text(app.mResource.strings.tLanding3Title, style: app.mResource.fonts.title,),
          ),
          Expanded(
            child: Container(),
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding3H3,
            text: app.mResource.strings.tLanding3P3,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Container(
            height: 14,
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding3H2,
            text: app.mResource.strings.tLanding3P2,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Container(
            height: 14,
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding3H4,
            text: app.mResource.strings.tLanding3P4,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Expanded(
            child: Container(),
          ),
          const SizedBox(
            height: 70,
          ),
        ],
      );
    }
    if (index == 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(40, 10, 40, 0),
            child: Text(app.mResource.strings.tLanding4Title, style: app.mResource.fonts.title,),
          ),
          Expanded(
            child: Container(),
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding4H1,
            text: app.mResource.strings.tLanding4P1,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Container(
            height: 14,
          ),
          CustomTextBox(
            header: app.mResource.strings.tLanding4H2,
            text: app.mResource.strings.tLanding4P2,
            height: 80,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Container(
            height: 14,
          ),
          CarouselSlider.builder(
            itemCount: app.mResource.strings.brands.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: CustomBox(
                  height: 140,
                  width: (MediaQuery.of(context).size.width * 0.5) - 20,
                  child: Column(
                    children: [
                      Container(
                        height: 115,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Image.asset(app.mResource.images.brands[index], width: 135, height: 135,),
                        ),
                      ),
                      Text(app.mResource.strings.brands[index], style: app.mResource.fonts.smallThick,),
                      Text(app.mResource.strings.brandsKorean[index], style: app.mResource.fonts.smaller),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              viewportFraction: 0.5,
              initialPage: 0,
              enableInfiniteScroll: true,
              pageSnapping: true,
              scrollDirection: Axis.horizontal,
              scrollPhysics: const BouncingScrollPhysics(),
            ),
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    app.mPage.nextPage(const TermsPage());
                  },
                  child: Text(app.mResource.strings.bTerms, style: app.mResource.fonts.baseUnderline,),
                ),
              ),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: const Text(" / "),
              ),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    app.mPage.nextPage(const PolicyPage());
                  },
                  child: Text(app.mResource.strings.bPolicy, style: app.mResource.fonts.baseUnderline,),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          const SizedBox(
            height: 70,
          ),
        ],
      );
    }
    else {
      return Container();
    }
  }
}


