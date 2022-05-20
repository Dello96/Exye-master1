import 'package:exye_app/Data/product.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/Widgets/custom_image.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:flutter/material.dart';
import 'package:exye_app/utils.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;
    int totalOldPrice = 0;
    return Column(
      children: [
        CustomShortHeader(app.mResource.strings.hReceipt),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.mData.user!.receipt!.date.toString().substring(0, 4) + " . " + app.mData.user!.receipt!.date.toString().substring(4, 6) + " . " + app.mData.user!.receipt!.date.toString().substring(6, 8), style: app.mResource.fonts.headerLight,),
                    ],
                  ),
                );
              }
              else if (index < app.mData.products!.length + 1) {
                return buildProductTile(context, app.mData.products![index - 1]);
              }
              else {
                totalOldPrice = 0;
                totalPrice = 0;
                for (int i = 0; i < app.mData.products!.length; i++) {
                  totalPrice += app.mData.products![i].price;
                  totalOldPrice += app.mData.products![i].priceOld;
                }
                return Container(
                  margin: const EdgeInsets.fromLTRB(60, 15, 60, 20),
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
                              child: Text("할인 전 가격", style: app.mResource.fonts.confirmLabel),
                            ),
                            Text(totalOldPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: app.mResource.fonts.confirmPriceStriked),
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
                              child: Text("총 결제가격", style: app.mResource.fonts.confirmLabel),
                            ),
                            Text(totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: app.mResource.fonts.confirmPrice),
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
          ),
        ),
        const CustomFooterToHome(),
      ],
    );
  }

  Widget buildProductTile (BuildContext context, Product product) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: CustomBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Row(
              children: [
                CustomNetworkImage(
                  url: product.thumbnail,
                  height: 105,
                  width: 90,
                  fit: BoxFit.fitHeight,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand, style: app.mResource.fonts.productBrand,),
                      Container(
                        height: 2,
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.topLeft,
                        child: Text(product.name, style: app.mResource.fonts.cartName,),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                Container(
                                  height: 2,
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
                            Expanded(
                              child: Container(),
                            ),
                            Text(app.mResource.strings.lSize + ": " + product.sizes[app.mData.user!.receipt!.sizes[product.id]], style: app.mResource.fonts.bold,),
                          ],
                        ),
                      ),
                    ],
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
