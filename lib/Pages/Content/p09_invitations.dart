import 'dart:io';
import 'package:exye_app/Pages/Content/p04_home.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/Widgets/custom_textfield.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({Key? key}) : super(key: key);

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  PageController control = PageController();
  int state = 0;

  void next () {
    app.mApp.input.clearAll();
    control.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void prev () {
    control.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (control.page! < 0) {
          prev();
          return false;
        }
        return true;
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: buildPageView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView () {
    return PageView(
      controller: control,
      physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        buildPageOne(),
        buildPageTwo(),
      ],
    );
  }

  Widget buildPageOne () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomHeader(app.mResource.strings.hInvitations),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(app.mResource.strings.pInvitation1 + app.mData.user!.invitations.toString() + "장", style: app.mResource.fonts.headerLight,),
              Container(
                height: 20,
              ),
              Text(app.mResource.strings.pInvitation2, style: app.mResource.fonts.landing,),
            ],
          ),
        ),
        Expanded(flex: 1,child: Container()),
        CustomHybridButton(
          image: app.mResource.images.bContacts,
          text: app.mResource.strings.bContacts,
          style: app.mResource.fonts.bold16,
          function: () async {
            app.mApp.input.clearAll();
            try {
              PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
              next();
              setState(() {
                app.mApp.input.textControl.text = contact.phoneNumber?.number?.replaceAll(RegExp(r'[^0-9]'), '') ?? "";
              });
            }
            catch (e) {
              app.mOverlay.overlayOff();
            }
          },
          height: 50,
          width: 250,
          colourPressed: app.mResource.colours.buttonLight,
          colourUnpressed: app.mResource.colours.buttonLight,
        ),
        Container(
          height: 30,
        ),
        CustomHybridButton(
          image: app.mResource.images.bDial,
          text: app.mResource.strings.bDial,
          style: app.mResource.fonts.bold16,
          function: () async {
            app.mApp.input.clearAll();
            next();
          },
          height: 50,
          width: 250,
          colourPressed: app.mResource.colours.buttonLight,
          colourUnpressed: app.mResource.colours.buttonLight,
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
        const CustomFooter(),
      ],
    );
  }

  Widget buildPageTwo () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomHeader(app.mResource.strings.hInvitations2),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          alignment: Alignment.centerLeft,
          child: Text(app.mResource.strings.pInvitation3, style: app.mResource.fonts.headerLight,),
        ),
        Container(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(app.mResource.strings.pInvitation4, style: app.mResource.fonts.base,)
        ),
        Container(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 40) / 4,
                child: Text(app.mResource.strings.pAreas1, style: app.mResource.fonts.bold,),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 40) / 4,
                child: Text(app.mResource.strings.pAreas2, style: app.mResource.fonts.bold,),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 40) / 4,
                child: Text(app.mResource.strings.pAreas3, style: app.mResource.fonts.bold,),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 40) / 4,
                child: Text(app.mResource.strings.pAreas4, style: app.mResource.fonts.bold,),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: CustomTextField(
            control: app.mApp.input.textControl,
            index: 1,
            text: app.mResource.strings.iPhoneNumber,
            node: app.mApp.node,
            maxLength: 13,
            fullFunction: () {},
          ),
        ),
        Expanded(
          child: Container(),
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
          button2: CustomHybridButton(
            image: app.mResource.images.bInvite,
            text: app.mResource.strings.bSendInvitation,
            style: app.mResource.fonts.bold16,
            function: () async {
              if (app.mApp.input.textControl.text.isEmpty) {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aNoNumber, text: app.mResource.strings.eNoNumber);
                app.mApp.input.clearAll();
                return;
              }
              bool tmp = await app.mData.numberInUse(app.mApp.input.textControl.text.replaceAll(RegExp(r'[^0-9]'), ''));
              if (!tmp) {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aNumberInUse, text: app.mResource.strings.eNumberInUse);
                app.mApp.input.clearAll();
                return;
              }
              Uri smsUrl = Uri(
                scheme: "sms",
                path: app.mApp.input.textControl.text.replaceAll(RegExp(r'[^0-9]'), ''),
              );
              if (Platform.isAndroid) {
                await launch("sms:${app.mApp.input.textControl.text.replaceAll(RegExp(r'[^0-9]'), '')}?body=tasting 서비스에 초대합니다. VIP 전용 서비스라 반드시 본인 전화번호로만 가입이 가능합니다. 아래 링크 확인해주세요! https://play.google.com/store/apps/details?id=com.exye.app.exye_app");
              }
              if (Platform.isIOS) {
                await launch(Uri.encodeFull("sms:${app.mApp.input.textControl.text.replaceAll(RegExp(r'[^0-9]'), '')}&body=tasting 서비스에 초대합니다. VIP 전용 서비스라 반드시 본인 전화번호로만 가입이 가능합니다. 아래 링크 확인해주세요! https://play.google.com/store/apps/details?id=com.exye.app.exye_app"));
              }
              await app.mData.createInvitation(app.mApp.input.textControl.text.replaceAll(RegExp(r'[^0-9]'), ''));
              app.mApp.input.clearAll();
              app.mPage.newPage(const HomePage());
              await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aInvitationSent, text: app.mResource.strings.apInvitationSent);
            },
            height: 50,
            colourUnpressed: app.mResource.colours.buttonOrange,
            colourPressed: app.mResource.colours.buttonOrange,
          ),
        ),
      ],
    );
  }
}
