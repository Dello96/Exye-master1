import 'package:exye_app/Pages/Content/p04_home.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_divider.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String text;
  const CustomHeader(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              app.mPage.newPage(const HomePage());
            },
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              height: 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(app.mResource.images.logo),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerLeft
                ),
              ),
            ),
          ),
          Container(
            height: 65,
          ),
          Text(text, style: app.mResource.fonts.headerLarge,),
          Container(
            height: 10,
          ),
          const CustomHeaderDivider(),
        ],
      ),
    );
  }
}

class CustomHeaderIndicator extends StatelessWidget {
  final String text;
  final int index;
  const CustomHeaderIndicator(this.text, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              //app.mPage.newPage(const HomePage());
            },
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              height: 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(app.mResource.images.logo),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft
                ),
              ),
            ),
          ),
          Container(
            height: 65,
          ),
          Text(text, style: app.mResource.fonts.headerLarge,),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: getIndicators(context),
          ),
        ],
      ),
    );
  }

  List<Widget> getIndicators (BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < 5; i++) {
      widgets.add(
        Container(
          width: (MediaQuery.of(context).size.width - 50) / 5,
          height: (index > i) ? 3 : 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: app.mResource.colours.black,
          ),
        ),
      );
    }
    return widgets;
  }
}

class CustomHeaderInactive extends StatelessWidget {
  final String text;
  const CustomHeaderInactive(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              //app.mPage.newPage(const HomePage());
            },
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              height: 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(app.mResource.images.logo),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft
                ),
              ),
            ),
          ),
          Container(
            height: 65,
          ),
          Text(text, style: app.mResource.fonts.headerLarge,),
          Container(
            height: 10,
          ),
          const CustomHeaderDivider(),
        ],
      ),
    );
  }
}

class CustomShortHeader extends StatelessWidget {
  final String text;
  const CustomShortHeader(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              app.mPage.newPage(const HomePage());
            },
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              height: 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(app.mResource.images.logo),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft
                ),
              ),
            ),
          ),
          Container(
            height: 20,
          ),
          Text(text, style: app.mResource.fonts.headerLarge,),
          Container(
            height: 10,
          ),
          const CustomHeaderDivider(),
        ],
      ),
    );
  }
}
