import 'package:exye_app/Data/product.dart';
import 'package:exye_app/Pages/Content/p04_home.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/Widgets/custom_image.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({Key? key}) : super(key: key);

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  int totalPriceOld = 0;
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return buildPage();
  }

  Widget buildPage () {
    return Column(
      children: [
        CustomShortHeader(app.mResource.strings.hConfirm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            width: MediaQuery.of(context).size.width,
            child: buildList(),
          ),
        ),
        CustomFooter(
            button1: CustomHybridButton(
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
          button2: CustomHybridButton(
            image: app.mResource.images.bCheckBlack,
            text: app.mResource.strings.bConfirmPurchase + " (" + app.mData.chosen!.length.toString() + ")",
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () async {
              await app.mApp.buildActionDialog(context, app.mResource.strings.aConfirmPurchase, app.mResource.strings.apConfirmPurchase, label1: app.mResource.strings.bConfirmPurchase2, label2: app.mResource.strings.bCancel,
                action: () async {
                  await app.mOverlay.overlayOn();
                  app.mData.nextStage();
                  List<Product> data = [];
                  for (int i = 0; i < app.mData.products!.length; i++) {
                    if (!(app.mData.chosen!.contains(app.mData.products![i]))) {
                      data.add(app.mData.products![i]);
                    }
                  }
                  await app.mData.postReturn(data, app.mData.user!.order!.sizes);
                  await app.mData.createReceipt();
                  app.mPage.newPage(const HomePage());
                  await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aPurchased, text: app.mResource.strings.apPurchased);
                  await app.mOverlay.overlayOff();
                }
              );
            },
            colourUnpressed: app.mResource.colours.buttonOrange,
            colourPressed: app.mResource.colours.buttonOrange,
          ),
        ),
      ],
    );
  }

  Widget buildList () {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.mResource.strings.pCart1, style: app.mResource.fonts.headerLight,),
                Container(
                  height: 10,
                ),
                Text(app.mResource.strings.pCart2, style: app.mResource.fonts.base,),
              ],
            ),
          );
        }
        else if (index < app.mData.products!.length + 1) {
          return buildItem(app.mData.products![index - 1]);
        }
        else {
          totalPrice = 0;
          totalPriceOld = 0;
          for (int i = 0; i < app.mData.chosen!.length; i++) {
            totalPriceOld += app.mData.chosen![i].priceOld;
            totalPrice += app.mData.chosen![i].price;
          }
          return Container(
            margin: const EdgeInsets.fromLTRB(60, 15, 60, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("총 상품금액", style: app.mResource.fonts.confirmLabelInactive),
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.centerRight,
                        child: Text(totalPriceOld.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: app.mResource.fonts.confirmPriceStriked),
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(app.mResource.strings.lPrice, style: app.mResource.fonts.confirmUnit),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("기본할인 적용 후", style: (app.mData.chosen!.length == 3) ? app.mResource.fonts.confirmLabelInactive : app.mResource.fonts.confirmLabel),
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.centerRight,
                        child: Text(totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: (app.mData.chosen!.length == 3) ? app.mResource.fonts.confirmPriceInactive : app.mResource.fonts.confirmPrice)
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(app.mResource.strings.lPrice, style: app.mResource.fonts.confirmUnit),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text("추가 10% 적용 후", style: (app.mData.chosen!.length == 3) ? app.mResource.fonts.confirmLabel : app.mResource.fonts.confirmLabelInactive),
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.centerRight,
                        child: Text((totalPrice*0.9).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: (app.mData.chosen!.length == 3) ? app.mResource.fonts.confirmPrice : app.mResource.fonts.confirmPriceInactive)
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(app.mResource.strings.lPrice, style: app.mResource.fonts.confirmUnit),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
      itemCount: app.mData.products!.length + 2,
    );
  }

  Widget buildItem (Product product) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: CustomBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Row(
              children: [
                CustomNetworkImage(
                  url: product.thumbnail,
                  height: 140,
                  width: 100,
                  fit: BoxFit.fitHeight,
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand, style: app.mResource.fonts.productBrand,),
                      Text(product.name, style: app.mResource.fonts.cartName,),
                      Container(
                        height: 5,
                      ),
                      Text(app.mResource.strings.lSize + ": " + app.mData.user!.order!.sizes[product.id], style: app.mResource.fonts.bold,),
                      Container(
                        height: 5,
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: product.priceOld.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                style: app.mResource.fonts.cartOldPrice,
                              ),
                              TextSpan(
                                text: "  원",
                                style: app.mResource.fonts.cartPriceUnit,
                              ),
                            ]
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                style: app.mResource.fonts.cartPrice,
                              ),
                              TextSpan(
                                text: "  원",
                                style: app.mResource.fonts.cartPriceUnit,
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  child: CustomImageToggle(
                    image: app.mResource.images.bCheckEmpty,
                    imagePressed: app.mResource.images.bCheckFilled,
                    width: 40,
                    height: 40,
                    function: () {
                      if (app.mData.chosen!.contains(product)) {
                        app.mData.chosen!.remove(product);
                        totalPriceOld -= product.priceOld;
                        totalPrice -= product.price;
                      }
                      else {
                        app.mData.chosen!.add(product);
                        totalPriceOld += product.priceOld;
                        totalPrice += product.price;
                      }
                      setState(() {
                        //do nothing
                      });
                    },
                    colourUnpressed: app.mResource.colours.transparent,
                    colourPressed: app.mResource.colours.black,
                    initial: app.mData.chosen!.contains(product),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
