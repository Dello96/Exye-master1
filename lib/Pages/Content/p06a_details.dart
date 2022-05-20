import 'package:exye_app/Data/product.dart';
import 'package:exye_app/Pages/Content/p06_listing.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_image.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  final Function function;
  const DetailsPage(this.product, {required this.function, Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  PageController control = PageController();
  int page = 0;

  void listen () {
    setState(() {
      page = control.page!.round();
    });
  }

  @override
  void initState () {
    super.initState();
    control.addListener(listen);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: app.mResource.colours.white,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: PageView.builder(
            controller: control,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.product.links.length + 1,
            itemBuilder: (context, index) {
              if (index < widget.product.links.length - 1) {
                return Scaffold(
                  backgroundColor: app.mResource.colours.white,
                  body: Column(
                    children: [
                      Container(
                        height: 75,
                      ),
                      Expanded(
                        child: CustomNetworkImage(
                          url: widget.product.links[index],
                          height: double.infinity,
                          width: double.infinity,
                          fit: (index == widget.product.links.length - 1) ? BoxFit.fitHeight : BoxFit.fitWidth,
                        ),
                      ),
                      Container(
                        height: 70,
                      ),
                    ],
                  ),
                );
              }
              if (index == widget.product.links.length - 1) {
                return Scaffold(
                  backgroundColor: app.mResource.colours.white,
                  body: Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: widget.product.details.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              width: 20,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.done,
                                size: 15,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: Text(widget.product.details[index], style: app.mResource.fonts.detailsParagraph,),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
              else {
                return Scaffold(
                  backgroundColor: app.mResource.colours.white,
                  body: Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: widget.product.more.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              width: 20,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.done,
                                size: 15,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                child: Text(widget.product.more[index], style: app.mResource.fonts.detailsParagraph,),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 75,
          child: Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            color: app.mResource.colours.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
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
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(widget.product.images[(control.positions.isNotEmpty) ? (control.page!.round()) : 0], style: app.mResource.fonts.detailsHeader,),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 70,
          child: CustomFooterPrev(
            button2: (!(app.mData.user!.cart!.items!.contains(widget.product))) ? CustomImageButton(
              image: app.mResource.images.bCheckEmpty,
              width: 50,
              height: 50,
              function: () async {
                if (app.mData.user!.cart!.items!.length > 2) {
                  app.mApp.buildAlertDialog(context, header: app.mResource.strings.aChooseThree, text: app.mResource.strings.eChooseThree);
                  return;
                }
                app.mOverlay.loadOverlay(SizeButtons(widget.product, key: UniqueKey(), function: () {widget.function(); setState(() {});},), 200);
                await app.mOverlay.panelOn();
                widget.function();
              },
              colourUnpressed: app.mResource.colours.transparent,
              colourPressed: app.mResource.colours.transparent,
            ) : CustomTextButtonNoPadding(
              text: (widget.product.selected == -1) ? "" : widget.product.sizes[widget.product.selected],
              style: app.mResource.fonts.sizeWhite,
              width: 50,
              height: 50,
              function: () async {
                app.mOverlay.loadOverlay(SizeButtons(widget.product, key: UniqueKey(), function: () {widget.function(); setState(() {});},), 200);
                await app.mOverlay.panelOn();
                widget.function();
              },
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 20,
          width: 10,
          height: 100,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getScrollIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getScrollIndicator () {
    List<Widget> bars = [];
    for (int i = 0; i < widget.product.links.length + 1; i++) {
      bars.add(
        Container(
          width: (i == page) ? 3 : 1,
          height: (i == page) ? (90 / (widget.product.links.length + 3))*3 : (90 / (widget.product.links.length + 3)),
          decoration: BoxDecoration(
            color: app.mResource.colours.black,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
    return bars;
  }
}
