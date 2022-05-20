import 'package:exye_app/Data/product.dart';
import 'package:exye_app/Data/timeslot.dart';
import 'package:exye_app/Pages/Content/p04_home.dart';
import 'package:exye_app/Pages/Content/p07a_firsttime.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_calendar.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/Widgets/custom_image.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  PageController control = PageController();
  PageController calendarControl = PageController();
  Timeslot? date;
  int slot = 0;

  void next () {
    control.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void prev () {
    control.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (control.page! > 0) {
          if (calendarControl.page! > 0) {
            await calendarControl.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
            return false;
          }
          prev();
          return false;
        }
        return true;
      },
      child: PageView(
        controller: control,
        physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        scrollDirection: Axis.horizontal,
        allowImplicitScrolling: true,
        children: [
          buildPageOne(),
          buildPageTwo(),
          buildPageThree(),
        ],
      ),
    );
  }

  Widget buildPageOne () {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          CustomHeader(app.mResource.strings.hSchedule1),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
                  CustomHybridButton(
                    image: app.mResource.images.bSchedule,
                    text: app.mResource.strings.bScheduleApp,
                    style: app.mResource.fonts.bold16,
                    height: 50,
                    width: 250,
                    function: () async {
                      setState(() {

                      });
                      next();
                    },
                    colourUnpressed: app.mResource.colours.buttonLight,
                    colourPressed: app.mResource.colours.buttonLight,
                  ),
                  Container(
                    height: 30,
                  ),
                  CustomHybridButton(
                    image: app.mResource.images.bCall,
                    text: app.mResource.strings.bScheduleCall,
                    style: app.mResource.fonts.bold16,
                    height: 50,
                    width: 250,
                    function: () async {
                      await app.mApp.call();
                      app.mPage.newPage(const HomePage());
                    },
                    colourUnpressed: app.mResource.colours.buttonLight,
                    colourPressed: app.mResource.colours.buttonLight,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          CustomFooterToHome(
            button2: CustomHybridButton(
              image: app.mResource.images.bPrev,
              text: app.mResource.strings.bPrev,
              style: app.mResource.fonts.bold16,
              height: 50,
              function: () async {
                app.mPage.prevPage();
              },
              colourPressed: app.mResource.colours.buttonLight,
              colourUnpressed: app.mResource.colours.buttonLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageTwo () {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: CustomCalendar(
              control: calendarControl,
              back: () {
                prev();
              },
              finish: (Timeslot x, int y) {
                setState(() {
                  date = x;
                  slot = y;
                });
                next();
              },
              type: 1,
            ),
          ),
          Container(),
        ],
      ),
    );
  }

  Widget buildPageThree () {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              CustomHeader(app.mResource.strings.hSchedule3),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: app.mData.user!.cart!.items!.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: CustomBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 20, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 75,
                                      alignment: Alignment.center,
                                      child: Text(app.mResource.strings.lDate, style: app.mResource.fonts.base,),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      width: 25,
                                      alignment: Alignment.center,
                                      child: CustomImageButton(
                                        image: app.mResource.images.bAdd,
                                        height: 20,
                                        width: 20,
                                        function: () {
                                          calendarControl.animateToPage(0, duration: const Duration(milliseconds: 200), curve: Curves.linear);
                                          setState(() {
                                            prev();
                                          });
                                        },
                                        colourUnpressed: app.mResource.colours.transparent,
                                        colourPressed: app.mResource.colours.transparent,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text((date?.month.toString() ?? "_") + app.mResource.strings.cMonth + " " + (date?.day.toString() ?? "_") + app.mResource.strings.cDay + " " + (app.mResource.strings.weekdays[(date?.weekday ?? -1) + 1]), style: app.mResource.fonts.bold,),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 75,
                                      alignment: Alignment.center,
                                      child: Text(app.mResource.strings.lTime, style: app.mResource.fonts.base,),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      width: 25,
                                      alignment: Alignment.center,
                                      child: CustomImageButton(
                                        image: app.mResource.images.bAdd,
                                        height: 20,
                                        width: 20,
                                        function: () {
                                          setState(() {
                                            prev();
                                          });
                                        },
                                        colourUnpressed: app.mResource.colours.transparent,
                                        colourPressed: app.mResource.colours.transparent,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(slot.toString() + " " + app.mResource.strings.cTime, style: app.mResource.fonts.bold,),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 75,
                                      alignment: Alignment.center,
                                      child: Text(app.mResource.strings.lAddress, style: app.mResource.fonts.base,),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      width: 25,
                                      alignment: Alignment.center,
                                      child: CustomImageButton(
                                        image: app.mResource.images.bAdd,
                                        height: 20,
                                        width: 20,
                                        function: () async {
                                          app.mOverlay.overlayOff();
                                          await app.mPage.nextPage(const SecondTimePage()).then((result) {
                                            setState(() {
                                              //do nothing;;
                                            });
                                          });
                                        },
                                        colourUnpressed: app.mResource.colours.transparent,
                                        colourPressed: app.mResource.colours.transparent,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(app.mData.user!.address!, style: app.mResource.fonts.bold,),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 75,
                                      alignment: Alignment.center,
                                      child: Text(app.mResource.strings.lName, style: app.mResource.fonts.base,),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Text(app.mData.user!.name ?? "", style: app.mResource.fonts.bold,),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 75,
                                      alignment: Alignment.center,
                                      child: Text(app.mResource.strings.lPhoneNumber, style: app.mResource.fonts.base,),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      width: 25,
                                    ),
                                    Expanded(
                                      child: Text((app.mData.user!.phoneNumber ?? "01000000000").replaceAllMapped(RegExp(r'(\d{3})(\d{3,4})(\d{4})'), (m) => '${m[1]}-${m[2]}-${m[3]}'), style: app.mResource.fonts.bold,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    if (index == app.mData.user!.cart!.items!.length + 1) {
                      int total = 0;
                      int realTotal = 0;
                      for (int i = 0; i < app.mData.user!.cart!.items!.length; i++) {
                        total += app.mData.user!.cart!.items![i].priceOld;
                        realTotal += app.mData.user!.cart!.items![i].price;
                      }
                      return Container(
                        margin: const EdgeInsets.fromLTRB(40, 15, 40, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text("총 합계", style: app.mResource.fonts.totalPriceLabel),
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Text(total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: app.mResource.fonts.totalPriceNumber),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(app.mResource.strings.lPrice, style: app.mResource.fonts.totalPriceUnit),
                                ),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text("할인 후 예상 총 합계", style: app.mResource.fonts.realPriceLabel),
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Text(realTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: app.mResource.fonts.realPriceNumber),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(app.mResource.strings.lPrice, style: app.mResource.fonts.realPriceUnit),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                            ),
                          ],
                        ),
                      );
                    }
                    else {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                        child: buildProductTile(app.mData.user!.cart!.items![index - 1])
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 70,
          child: CustomFooter(
            button1: CustomHybridButton(
              image: app.mResource.images.bPrev,
              text: app.mResource.strings.bPrev,
              style: app.mResource.fonts.bold16,
              height: 50,
              function: () {
                setState(() {
                  prev();
                });
              },
              colourUnpressed: app.mResource.colours.buttonLight,
              colourPressed: app.mResource.colours.buttonLight,
            ),
            button2: CustomTextButton(
              text: app.mResource.strings.bBook,
              style: app.mResource.fonts.bold16,
              height: 50,
              function: () async {
                await app.mData.nextStage();
                await app.mData.postOrder(app.mData.user!.cart!.items!, app.mData.user!.cart!.sizes!);
                await app.mData.createOrder(date!, slot);
                app.mPage.newPage(const HomePage());
                await app.mApp.buildAlertDialog(context, header: app.mData.user!.order!.year.toString() + app.mResource.strings.cYear + " " + app.mData.user!.order!.month.toString() + app.mResource.strings.cMonth + " " + app.mData.user!.order!.day.toString() + app.mResource.strings.cDay + " " + app.mData.user!.order!.timeslot.toString() + app.mResource.strings.cTime, text: app.mResource.strings.apOrdered);
              },
              colourUnpressed: app.mResource.colours.buttonOrange,
              colourPressed: app.mResource.colours.buttonOrange,
            ),
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
                            Text("Size: " + product.sizes[product.selected], style: app.mResource.fonts.bold,),
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
