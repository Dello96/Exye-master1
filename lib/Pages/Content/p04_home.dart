import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exye_app/Data/timeslot.dart';
import 'package:exye_app/Data/user.dart';
import 'dart:io';
import 'package:exye_app/Pages/Content/p00_landing.dart';
import 'package:exye_app/Pages/Content/p05_schedule.dart';
import 'package:exye_app/Pages/Content/p06_listing.dart';
import 'package:exye_app/Pages/Content/p08_appointments.dart';
import 'package:exye_app/Pages/Content/p09_invitations.dart';
import 'package:exye_app/Pages/Content/p10_services.dart';
import 'package:exye_app/Pages/Content/p11_confirm.dart';
import 'package:exye_app/Pages/Content/p12_receipt.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_divider.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future init;

  @override
  void initState () {
    super.initState();
    init = app.mData.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return buildColumn();
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildColumn () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomHeader(app.mData.user!.name! + app.mResource.strings.hHome),
        buildStageTracker(),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: const CustomHeaderDivider(),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getMainButton(),
              Container(
                height: 30,
              ),
              CustomHybridButton(
                image: (app.mData.user!.invitations == 0)? app.mResource.images.bInviteInactive : app.mResource.images.bInvite,
                text: app.mResource.strings.bInvite + " (" + app.mData.user!.invitations.toString() + ")",
                style: app.mResource.fonts.bold16,
                height: 50,
                width: 300,
                function: () async {
                  //await generateData();
                  //print("Done");
                  app.mApp.input.textControl.text = "010";
                  app.mApp.node.requestFocus();
                  app.mPage.nextPage(const InvitationsPage());
                },
                colourPressed: app.mResource.colours.buttonLight,
                colourUnpressed: app.mResource.colours.buttonLight,
                active: (app.mData.user!.invitations == 0) ? false : true,
              ),
              Container(
                height: 30,
              ),
              CustomHybridButton3(
                image: app.mResource.images.logo,
                text: app.mResource.strings.bAbout,
                style: app.mResource.fonts.bold16,
                height: 50,
                width: 300,
                function: () async {
                  //await generateData();
                  //print("Done");
                  app.mPage.nextPage(const ServicesPage());
                },
                colourPressed: app.mResource.colours.buttonLight,
                colourUnpressed: app.mResource.colours.buttonLight,
              ),
              Container(
                height: 30,
              ),
              CustomHybridButton(
                image: app.mResource.images.bLogOut,
                text: app.mResource.strings.bLogOut,
                style: app.mResource.fonts.bold16,
                height: 50,
                width: 300,
                function: () async {
                  await app.mApp.buildActionDialog(
                    context,
                    app.mResource.strings.aLogOut,
                    app.mResource.strings.pLogOut,
                    action: () {
                      FirebaseAuth.instance.signOut();
                      app.mPage.newPage(const LandingPage());
                    },
                  );
                },
                colourPressed: app.mResource.colours.buttonLight,
                colourUnpressed: app.mResource.colours.buttonLight,
              ),
            ],
          ),
        ),
        Container(),
      ],
    );
  }

  Widget getMainButton () {
    if (app.mData.user!.stage == 0) {
      return CustomHybridButton(
        image: app.mResource.images.bShopping,
        text: app.mResource.strings.bMainButton[0],
        style: app.mResource.fonts.bold16,
        height: 50,
        width: 300,
        function: () async {
          //await app.mData.accessApi();
          await app.mData.getStock();
          await app.mData.getProductData();
          app.mPage.nextPage(const ListingsPage());
          app.mData.getAllProducts();
        },
        colourUnpressed: app.mResource.colours.buttonOrange,
        colourPressed: app.mResource.colours.buttonOrange,
      );
    }

    if (app.mData.user!.stage == 1) {
      if ((app.mData.user!.order!.year * 10000 + app.mData.user!.order!.month * 100 + app.mData.user!.order!.day) == (DateTime.now().year * 1000 + DateTime.now().month * 100 + DateTime.now().day)) {
        return Container(
          height: 50,
        );
      }
      else {
        return CustomHybridButton(
          image: app.mResource.images.bScheduleWhite,
          text: app.mResource.strings.bMainButton[1],
          style: app.mResource.fonts.bWhite16,
          height: 50,
          width: 300,
          function: () async {
            await app.mData.getOrderItemData();
            await app.mData.getCalendarData(app.mData.user!.order!.year, app.mData.user!.order!.month);
            app.mPage.nextPage(const EditOrdersPage());
          },
          //colourUnpressed: app.mResource.colours.buttonOrange,
          //colourPressed: app.mResource.colours.buttonOrange,
        );
      }
    }
    if (app.mData.user!.stage == 2) {
      return CustomHybridButton(
        image: app.mResource.images.bShopping,
        text: app.mResource.strings.bMainButton[2],
        style: app.mResource.fonts.bold16,
        height: 50,
        width: 300,
        function: () async {
          await app.mData.getOrderItemData();
          app.mPage.nextPage(const ConfirmPage());
        },
        colourUnpressed: app.mResource.colours.buttonOrange,
        colourPressed: app.mResource.colours.buttonOrange,
      );
    }
    if (app.mData.user!.stage == 3) {
      return CustomHybridButton(
        image: app.mResource.images.bShopping,
        text: app.mResource.strings.bMainButton[3],
        style: app.mResource.fonts.bold16,
        height: 50,
        width: 300,
        function: () async {
          await app.mData.getReceiptData();
          app.mPage.nextPage(const ReceiptPage());
        },
        colourUnpressed: app.mResource.colours.buttonOrange,
        colourPressed: app.mResource.colours.buttonOrange,
      );
    }
    else {
      return Container(
        height: 50,
      );
    }
  }

  Widget buildStageTracker () {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(app.mResource.strings.hShoppingStage, style: app.mResource.fonts.headerLight,),
          Container(
            height: 10,
          ),
          getStageText(app.mData.user!.stage),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildStage(0),
              buildStage(1),
              buildStage(2),
            ],
          ),
        ],
      ),
    );
  }

  Widget getStageText (int index) {
    if (index == 0) {
      return Text(app.mResource.strings.pShoppingStage(0), style: app.mResource.fonts.base,);
    }
    if (index == 1) {
      Order order = app.mData.user!.order!;
      if (DateTime.now().year == order.year &&
          DateTime.now().month == order.month &&
          DateTime.now().day == order.day) {
        return Text(app.mResource.strings.pShoppingStage(2), style: app.mResource.fonts.base,);
      }
      else {
        String dateString = order.year.toString() + app.mResource.strings.cYear + " " + order.month.toString() + app.mResource.strings.cMonth + " " + order.day.toString() + app.mResource.strings.cDay + " " + order.timeslot.toString() + app.mResource.strings.cTime;
        String phoneNumberString = app.mData.user!.phoneNumber!.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{4})+(?!\d))'), (Match m) => '${m[1]}-');
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: dateString, style: app.mResource.fonts.bold),
              TextSpan(text: app.mResource.strings.pShoppingStage(1), style: app.mResource.fonts.base),
              TextSpan(text: phoneNumberString, style: app.mResource.fonts.bold),
              TextSpan(text: app.mResource.strings.pShoppingStage(5), style: app.mResource.fonts.base),
            ]
          ),
        );//app.mResource.strings.pShoppingStage(1, param1: dateString, param2: phoneNumberString);
      }
    }
    if (index == 2) {
      return Text(app.mResource.strings.pShoppingStage(3), style: app.mResource.fonts.base,);
    }
    if (index == 3) {
      return Text(app.mResource.strings.pShoppingStage(4), style: app.mResource.fonts.base,);
    }
    return Container();
  }

  Widget buildStage (int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      width: 100,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: (app.mData.user!.stage == index) ? app.mResource.colours.black : app.mResource.colours.transparent,
              border: Border.all(color: (app.mData.user!.stage == index) ? app.mResource.colours.black : app.mResource.colours.inactiveDate),
            ),
            child: Text((index + 1).toString(), style: TextStyle(color: (app.mData.user!.stage == index) ? app.mResource.colours.fontWhite : app.mResource.colours.inactiveDate),),
          ),
          Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(app.mResource.strings.lShoppingStage[index], style: (app.mData.user!.stage == index) ? app.mResource.fonts.small : app.mResource.fonts.smallInactive,),
          ),
        ],
      ),
    );
  }
}

Future<void> generateData () async {
  CollectionReference timeslotsRef = FirebaseFirestore.instance.collection('dates');
  Map<dynamic, dynamic> schedule = {};
  Map<dynamic, dynamic> available = {};
  DateTime tmp = DateTime(2022, 1, 1);
  int year = 2022;
  int month = 1;
  int start = tmp.weekday;
  schedule[tmp.day.toString()] = ["", "", "", "", "", "", "", "", "", "",];
  available[tmp.day.toString()] = (tmp.weekday == 7) ? 0 : 2;
  for (int i = 0; i < 500; i++) {
    tmp = tmp.add(const Duration(days: 1));
    if (tmp.month != month) {
      await timeslotsRef.doc("${year * 100 + month}").set({
        "year": year,
        "month": month,
        "start": start,
        "available": available,
        "slots": schedule,
      });
      year = tmp.year;
      month = tmp.month;
      start = tmp.weekday;
      schedule = {};
      available = {};
    }
    schedule[tmp.day.toString()] = ["", "", "", "", "", "", "", "", "", "",];
    available[tmp.day.toString()] = (tmp.weekday == 7) ? 0 : 2;
  }
}

Future<void> generateData2 () async {
  CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
  for (int i = 0; i < 10; i++) {
    await productsRef.add({
      "brand": "Gucci",
      "name": "Abney Jet Recycled Neps Henley Jean",
      "priceOld": 4833000,
      "price": 2900000,
      "details": ["Hey", "No", "Good Afternoon",],
      "more": ["Great", "No thanks",],
      "images": ["Front", "Back", "Close Up"],
    });
  }
}
