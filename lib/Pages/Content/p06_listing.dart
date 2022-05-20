import 'package:exye_app/Data/product.dart';
import 'package:exye_app/Pages/Content/p06a_details.dart';
import 'package:exye_app/Pages/Content/p06b_filter.dart';
import 'package:exye_app/Pages/Content/p07_checkout.dart';
import 'package:exye_app/Pages/Content/p07a_firsttime.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/Widgets/custom_image.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  PageController control = PageController();


  void next () {
    control.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void prev () {
    control.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void changeState () {
    setState(() {
      //do nothing?
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (control.page! > 0) {
          prev();
          return false;
        }
        return true;
      },
      child: PageView(
        controller: control,
        physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          buildPageOne(),
          buildPageTwo()
        ],
      ),
    );
  }

  Widget buildPageOne () {
    return Stack(
      children: [
        ListingsCards(changeState),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 70,
          child: CustomFooter(
            button1: CustomImageButton(
              image: app.mResource.images.bSearch,
              height: 50,
              width: 50,
              function: () async {
                app.mOverlay.loadOverlay(const FilterOverlay(), 450);
                await app.mOverlay.panelOn();
                setState(() {
                  //Do something
                });
              },
              colourPressed: app.mResource.colours.buttonLight,
              colourUnpressed: app.mResource.colours.buttonLight,
            ),
            button2: CustomHybridButton(
              text: app.mResource.strings.bCart + " (" + app.mData.user!.cart!.itemIds!.length.toString() + ")",
              style: app.mResource.fonts.bWhite16,
              image: app.mResource.images.bCart,
              height: 50,
              function: () async {
                if (app.mData.user!.cart!.items!.length == app.mData.user!.cart!.itemIds!.length) {
                  setState(() {});
                  next();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPageTwo () {
    return Column(
      children: [
        CustomShortHeader(app.mResource.strings.hListing2),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ((app.mData.user!.cart!.items?.length ?? 0) >= 3) ? (app.mData.user!.cart!.items?.length ?? 3) : 3,
              itemBuilder: (context, index) {
                if ((app.mData.user!.cart!.items?.length ?? 0) > index) {
                  return buildProductTile(app.mData.user!.cart!.items![index]);
                }
                else {
                  return Container();
                }
              },
            ),
          ),
        ),
        CustomFooter(
          button1: CustomHybridButton(
            image: app.mResource.images.bPrev,
            text: app.mResource.strings.bPrev,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () async {
              prev();
            },
            colourPressed: app.mResource.colours.buttonLight,
            colourUnpressed: app.mResource.colours.buttonLight,
          ),
          button2: CustomTextButton(
            text: app.mResource.strings.bBook + " (" + app.mData.user!.cart!.items!.length.toString() + ")",
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () async {
              if (app.mData.user!.cart!.items!.isEmpty) {
                app.mApp.buildAlertDialog(context, header: app.mResource.strings.aChooseZero, text: app.mResource.strings.eChooseZero);
                return;
              }
              if (app.mData.user!.address == "") {
                app.mPage.nextPage(const FirstTimePage());
              }
              else {
                await app.mData.getCalendarData(DateTime.now().year, DateTime.now().month);
                app.mPage.nextPage(const CheckOutPage());
              }
            },
            colourUnpressed: app.mResource.colours.buttonOrange,
            colourPressed: app.mResource.colours.buttonOrange,
          ),
        ),
      ],
    );
  }

  Widget buildProductTile (Product product) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: CustomBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                  height: 105,
                  width: 75,
                  child: CustomNetworkImage(
                    url: product.thumbnail,
                    height: 105,
                    width: 75,
                    fit: BoxFit.fitWidth,
                  ),
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
                            GestureDetector(
                              onTap: () async {
                                app.mOverlay.loadOverlay(SizeButtonsEdit(product, key: UniqueKey(), function: () {changeState();},), 200);
                                await app.mOverlay.panelOn();
                                changeState();
                              },
                              child: Container(
                                height: 30,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1,
                                    color: app.mResource.colours.black,
                                  ),
                                ),
                                child: Text(product.sizes[product.selected], style: app.mResource.fonts.bold,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: 0,
              width: 23,
              height: 23,
              child: CustomImageButton(
                image: app.mResource.images.bExit,
                height: 23,
                width: 23,
                function: () async {
                  setState(() {
                    app.mData.user!.cart!.items!.remove(product);
                  });
                  await app.mData.updateCart();
                },
                colourUnpressed: app.mResource.colours.transparent,
                colourPressed: app.mResource.colours.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListingsCards extends StatefulWidget {
  final Function function;
  const ListingsCards(this.function, {Key? key}) : super(key: key);

  @override
  _ListingsCardsState createState() => _ListingsCardsState();
}

class _ListingsCardsState extends State<ListingsCards> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        CustomShortHeader(app.mResource.strings.hListing1),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: app.mData.productIds!.length,
            itemBuilder: (context, index) {
              return loadPage(index);
            },
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }

  Widget loadPage (int index) {
    if ((app.mData.products ?? []).isNotEmpty) {
      int x = app.mData.products!.indexWhere((element) => element.id == app.mData.productIds![index]);
      if (x >= 0) {
        return buildPage(app.mData.products![x]);
      }
    }
    return FutureBuilder<Product>(
      future: app.mData.futures[index],
      builder: (context, AsyncSnapshot<Product> snapshot) {
        if (snapshot.hasError) {
          print("XD" + snapshot.error.toString());
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Product product = snapshot.data!;
          return buildPage(product);
        }
        else {
          return Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            //margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            decoration: BoxDecoration(
              color: app.mResource.colours.cardBackground,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(
                color: app.mResource.colours.boxShadow,
                blurRadius: 4,
                offset: Offset(2, 2),
              )],
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildPage (Product product) {
    return GestureDetector(
      key: Key(product.id),
      onTap: () {
        app.mPage.nextPage(DetailsPage(product, function: () {widget.function();},));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        //margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        decoration: BoxDecoration(
          color: app.mResource.colours.cardBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(
            color: app.mResource.colours.boxShadow,
            blurRadius: 4,
            offset: Offset(2, 2),
          )],
        ),
        child: buildContents(product),
      ),
    );
  }

  Widget buildContents (Product product) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(product.brand, style: app.mResource.fonts.productBrand,),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(product.name, style: app.mResource.fonts.productName,),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: MediaQuery.of(context).size.width,
              child: CustomNetworkImage(url: product.thumbnail, fit: BoxFit.fitWidth,),
            ),
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 30,
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: product.priceOld.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                style: app.mResource.fonts.productOldPrice,
                              ),
                              TextSpan(
                                text: "  원",
                                style: app.mResource.fonts.productPriceUnit,
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
                                style: app.mResource.fonts.productPrice,
                              ),
                              TextSpan(
                                text: "  원",
                                style: app.mResource.fonts.productPriceUnit,
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  width: 40,
                  height: 40,
                  child: (!(app.mData.user!.cart!.items!.contains(product))) ? CustomImageButton(
                    image: app.mResource.images.bCheckEmpty,
                    width: 40,
                    height: 40,
                    function: () async {
                      if (app.mData.user!.cart!.items!.length > 2) {
                        app.mApp.buildAlertDialog(context, header: app.mResource.strings.aChooseThree, text: app.mResource.strings.eChooseThree);
                        return;
                      }
                      app.mOverlay.loadOverlay(SizeButtons(product, key: UniqueKey(), function: () {widget.function();},), 200);
                      await app.mOverlay.panelOn();
                      widget.function();
                    },
                    colourUnpressed: app.mResource.colours.transparent,
                    colourPressed: app.mResource.colours.transparent,
                  ) : CustomTextButtonNoPadding(
                    text: (product.selected == -1) ? "" : product.sizes[product.selected],
                    style: app.mResource.fonts.sizeWhite,
                    width: 40,
                    height: 40,
                    function: () async {
                      app.mOverlay.loadOverlay(SizeButtons(product, key: UniqueKey(), function: () {widget.function();},), 200);
                      await app.mOverlay.panelOn();
                      widget.function();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SizeButtons extends StatefulWidget {
  final Product product;
  final Function function;
  const SizeButtons(this.product, {required this.function, Key? key}) : super(key: key);

  @override
  _SizeButtonsState createState() => _SizeButtonsState();
}

class _SizeButtonsState extends State<SizeButtons> {
  int tmpSelected = -1;

  @override
  void initState () {
    super.initState();
    tmpSelected = widget.product.selected;
  }

  @override
  Widget build (BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 0, 10),
            height: 25,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  height: 25,
                  alignment: Alignment.centerLeft,
                  child: Text(app.mResource.strings.pSizeSelect, style: app.mResource.fonts.base),
                ),
                GestureDetector(
                  onTap: () async {
                    //do something
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        bool gender = (widget.product.sizes[0] == "36");
                        return CupertinoAlertDialog(
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text((gender ? "여자" : "남자") + " 사이즈 가이드", style: app.mResource.fonts.bold16,),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                //height: 400,
                                width: MediaQuery.of(context).size.width,
                                alignment:Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  alignment:Alignment.center,
                                  child: Image.asset(gender ? app.mResource.images.sizeWomen : app.mResource.images.sizeMen),
                                ),
                              ),
                              CustomHybridButton(
                                image: app.mResource.images.bCall,
                                text: app.mResource.strings.bCall,
                                style: app.mResource.fonts.bold14,
                                height: 40,
                                width: 130,
                                function: () async {
                                  await app.mApp.call();
                                  //app.mPage.prevPage();
                                },
                                colourPressed: app.mResource.colours.buttonLight,
                                colourUnpressed: app.mResource.colours.buttonLight,
                              ),
                              Container(
                                height: 10,
                              ),
                              CustomHybridButton(
                                image: app.mResource.images.bKakao,
                                text: app.mResource.strings.bKakao,
                                style: app.mResource.fonts.bold14,
                                height: 40,
                                width: 130,
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
                    );
                  },
                  child: Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(app.mResource.images.bSizeGuide),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buildSizeButtons(),
          ),
          Container(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CustomTextButton(
                  text: app.mResource.strings.bCancelChange,
                  style: app.mResource.fonts.bold16,
                  height: 50,
                  function: () async {
                    bool tmp = true;
                    if (app.mData.user!.cart!.items!.contains(widget.product)) {
                      tmp = false;
                      app.mData.user!.cart!.items!.remove(widget.product);
                      await app.mData.updateCart();
                    }
                    widget.product.selected = -1;
                    widget.function();
                    await app.mOverlay.panelOff();
                    if (tmp == false) {
                      await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aRemoveCart, text: app.mResource.strings.pRemoveCart);
                    }
                  },
                  colourPressed: app.mResource.colours.buttonLight,
                  colourUnpressed: app.mResource.colours.buttonLight,
                ),
              ),
              Container(
                width: 20,
              ),
              Center(
                child: CustomTextButton(
                  text: app.mResource.strings.bConfirmChange,
                  style: app.mResource.fonts.bWhite16,
                  height: 50,
                  function: () async {
                    bool tmp = true;
                    if (tmpSelected == -1) {
                      await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aChooseSize, text: app.mResource.strings.eChooseSize);
                      return;
                    }
                    if (!app.mData.user!.cart!.items!.contains(widget.product)) {
                      int newStock = await app.mData.getSingleStock(widget.product.id + "_" + widget.product.sizes[tmpSelected]);
                      if (newStock == 0) {
                        await app.mOverlay.panelOff();
                        await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aNoStock, text: app.mResource.strings.eNoStock);
                        return;
                      }
                      tmp = false;
                      app.mData.user!.cart!.items!.add(widget.product);
                    }
                    widget.product.selected = tmpSelected;
                    await app.mData.updateCart();
                    widget.function();
                    await app.mOverlay.panelOff();
                    if (tmp == false) {
                      await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aAddCart, text: app.mResource.strings.pAddCart);
                    }
                  },
                ),
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  List<Widget> buildSizeButtons () {
    List<Widget> buttons = [];
    for (int i = 0; i < widget.product.sizes.length - 1; i++) {
      buttons.add(
        SizedBox(
          height: 70,
          width: 40,
          child: GestureDetector(
            onTap: () async {
              if (widget.product.stock![i] != 0) {
                setState(() {
                  tmpSelected = i;
                });
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (i == tmpSelected) ? app.mResource.colours.black : app.mResource.colours.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: app.mResource.colours.buttonBorder, width: 1, style: (widget.product.stock![i] == 0) ? BorderStyle.none : BorderStyle.solid),
                    ),
                    child: Text(widget.product.sizes[i], style: (i == tmpSelected) ? app.mResource.fonts.sizeWhite : ((widget.product.stock![i] == 0) ? app.mResource.fonts.sizeInactive : app.mResource.fonts.sizeButtons)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  width: 50,
                  alignment: Alignment.center,
                  child: Text((widget.product.stock![i] == 0) ? "품절" : "남음", style: (widget.product.stock![i] == 0) ? app.mResource.fonts.inactiveStock : app.mResource.fonts.boldStock,)
                ),
              ],
            ),
          ),
        ),
      );
    }
    return buttons;
  }
}

class SizeButtonsEdit extends StatefulWidget {
  final Product product;
  final Function function;
  const SizeButtonsEdit(this.product, {required this.function, Key? key}) : super(key: key);

  @override
  _SizeButtonsEditState createState() => _SizeButtonsEditState();
}

class _SizeButtonsEditState extends State<SizeButtonsEdit> {
  int tmpSelected = -1;

  @override
  void initState () {
    super.initState();
    tmpSelected = widget.product.selected;
  }

  @override
  Widget build (BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 0, 10),
            height: 25,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  height: 25,
                  alignment: Alignment.centerLeft,
                  child: Text(app.mResource.strings.pSizeSelect, style: app.mResource.fonts.base),
                ),
                GestureDetector(
                  onTap: () async {
                    //do something
                    await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          bool gender = (widget.product.sizes[0] == "36");
                          return CupertinoAlertDialog(
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text((gender ? "여자" : "남자") + " 사이즈 가이드", style: app.mResource.fonts.bold16,),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  //height: 400,
                                  width: MediaQuery.of(context).size.width,
                                  alignment:Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    alignment:Alignment.center,
                                    child: Image.asset(gender ? app.mResource.images.sizeWomen : app.mResource.images.sizeMen),
                                  ),
                                ),
                                CustomHybridButton(
                                  image: app.mResource.images.bCall,
                                  text: app.mResource.strings.bCall,
                                  style: app.mResource.fonts.bold14,
                                  height: 40,
                                  width: 130,
                                  function: () async {
                                    await app.mApp.call();
                                    //app.mPage.prevPage();
                                  },
                                  colourPressed: app.mResource.colours.buttonLight,
                                  colourUnpressed: app.mResource.colours.buttonLight,
                                ),
                                Container(
                                  height: 15,
                                ),
                                CustomHybridButton(
                                  image: app.mResource.images.bKakao,
                                  text: app.mResource.strings.bKakao,
                                  style: app.mResource.fonts.bold14,
                                  height: 40,
                                  width: 130,
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
                    );
                  },
                  child: Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(app.mResource.images.bSizeGuide),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buildSizeButtons(),
          ),
          Container(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CustomTextButton(
                  text: app.mResource.strings.bConfirmChange,
                  style: app.mResource.fonts.bWhite16,
                  height: 50,
                  function: () async {
                    bool tmp = true;
                    if (tmpSelected == -1) {
                      await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aChooseSize, text: app.mResource.strings.eChooseSize);
                      return;
                    }
                    widget.product.selected = tmpSelected;
                    await app.mData.updateCart();
                    widget.function();
                    await app.mOverlay.panelOff();
                    if (tmp == false) {
                      await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aAddCart, text: app.mResource.strings.pAddCart);
                    }
                  },
                ),
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  List<Widget> buildSizeButtons () {
    List<Widget> buttons = [];
    for (int i = 0; i < widget.product.sizes.length - 1; i++) {
      buttons.add(
        SizedBox(
          height: 70,
          width: 40,
          child: GestureDetector(
            onTap: () async {
              if (widget.product.stock![i] != 0) {
                setState(() {
                  tmpSelected = i;
                });
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: (i == tmpSelected) ? app.mResource.colours.black : app.mResource.colours.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: app.mResource.colours.buttonBorder, width: 1, style: (widget.product.stock![i] == 0) ? BorderStyle.none : BorderStyle.solid),
                    ),
                    child: Text(widget.product.sizes[i], style: (i == tmpSelected) ? app.mResource.fonts.sizeWhite : ((widget.product.stock![i] == 0) ? app.mResource.fonts.sizeInactive : app.mResource.fonts.sizeButtons)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  width: 50,
                  alignment: Alignment.center,
                  child: Text((widget.product.stock![i] == 0) ? "품절" : "남음", style: (widget.product.stock![i] == 0) ? app.mResource.fonts.inactiveStock : app.mResource.fonts.boldStock,)
                ),
              ],
            ),
          ),
        ),
      );
    }
    return buttons;
  }
}

