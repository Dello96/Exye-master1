import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exye_app/Pages/Content/p00_landing.dart';
import 'package:exye_app/Pages/Content/p01b_survey.dart';
import 'package:exye_app/Pages/Content/p01c_brands.dart';
import 'package:exye_app/Pages/Content/p04_home.dart';
import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/Widgets/custom_keyboard.dart';
import 'package:exye_app/Widgets/custom_page_view_element.dart';
import 'package:exye_app/Widgets/custom_terms.dart';
import 'package:exye_app/Widgets/custom_textbox.dart';
import 'package:exye_app/Widgets/custom_textfield.dart';
import 'package:exye_app/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  PageController control = PageController(
    initialPage: 0,
  );
  CustomTermsState termsState = CustomTermsState();
  CustomSurveyState surveyState = CustomSurveyState();
  CustomBrandsState brandsState = CustomBrandsState();

  Future<void> next () async {
    await control.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  Future<void> prev () async {
    await control.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void changeState () {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (control.page! > 5) {
          prev();
          return false;
        }
        return true;
      },
      child: PageView(
        controller: control,
        physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        scrollDirection: Axis.horizontal,
        children: [
          CustomPageViewElement(child: buildPage1()),
          CustomPageViewElementPassword(child: buildPage2()),
          CustomPageViewElement(child: buildPage3()),
          CustomPageViewElementPassword(child: buildPage4()),
          CustomPageViewElementPassword(child: buildPage4b()),
          CustomPageViewElement(child: buildPage5()),
          CustomPageViewElement(child: buildPage5a()),
          CustomPageViewElement(child: buildPage5b()),
          CustomPageViewElement(child: buildPage6()),
        ],
      ),
    );
  }

  Widget buildPage1 () {
    return Column(
      children: [
        CustomHeaderInactive(app.mResource.strings.hSignUp1),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          alignment: Alignment.centerLeft,
          child: Text(app.mResource.strings.pSignUp1, style: app.mResource.fonts.headerLight,),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0,),
          alignment: Alignment.centerLeft,
          child: Text(app.mResource.strings.pSignUp1a, style: app.mResource.fonts.base,),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                alignment: Alignment.center,
                child: CustomTextField(
                  control: app.mApp.input.textControl,
                  text: app.mResource.strings.iPhoneNumber,
                  node: app.mApp.node,
                  index: 0,
                  maxLength: 13,
                  fullFunction: () async {
                    app.mApp.node.unfocus();
                    if (app.mApp.input.textControl.text.length < 13) {
                      app.mApp.buildAlertDialog(context, header: app.mResource.strings.aInvalidNumber, text: app.mResource.strings.eInvalidNumber);
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    app.mApp.auth.setPhoneNumber(app.mApp.input.textControl.text.replaceAll(RegExp(r'[^0-9]'), ''));
                    app.mApp.input.clearAll();
                    await app.mOverlay.overlayOn();
                    CollectionReference invitationsRef = FirebaseFirestore.instance.collection('invitations');
                    List emailExists = await FirebaseAuth.instance.fetchSignInMethodsForEmail(app.mApp.auth.phoneNumber + "@exye.com");
                    if (emailExists.isNotEmpty) {
                      app.mApp.buildAlertDialog(context, header: app.mResource.strings.aAccountExists, text: app.mResource.strings.eAccountExists);
                      await app.mOverlay.overlayOff();
                      return;
                    }
                    QuerySnapshot snapshot = await invitationsRef.where('target', isEqualTo: app.mApp.auth.phoneNumber).get();
                    if (snapshot.docs.isEmpty) {
                      app.mApp.buildActionDialog(
                        context,
                        app.mResource.strings.aNoInvitation,
                        app.mResource.strings.eNoInvitation,
                        action: () async {
                          //save number
                          await app.mOverlay.overlayOff();
                        },
                        label1: app.mResource.strings.bLeaveNumber,
                        label2: app.mResource.strings.bPass,
                      );
                      await app.mOverlay.overlayOff();
                      return;
                    }
                    app.mApp.input.clearAll();
                    app.mApp.input.setActive(1);
                    try {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '+82 ' + app.mApp.auth.phoneNumber,
                        verificationCompleted: (PhoneAuthCredential cred) async {
                          app.mApp.input.setText(cred.smsCode ?? "000000", index: 1);
                        },
                        verificationFailed: (FirebaseAuthException e) async {
                          print(e);
                          await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aVerifyFailed, text: app.mResource.strings.eVerifyFailed);
                          await app.mOverlay.overlayOff();
                          app.mPage.prevPage();
                          return;
                        },
                        codeSent: (String verificationId, int? resendToken) async {
                          app.mApp.auth.setVerificationId(verificationId);
                          if (resendToken != null) {
                            app.mApp.auth.setResendToken(resendToken);
                          }
                          await next();
                          await app.mOverlay.overlayOff();
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    }
                    catch (error) {
                      print(error);
                      await app.mOverlay.overlayOff();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        CustomFooterToLanding(
          button: CustomHybridButton(
            image: app.mResource.images.bCheckFilled,
            text: app.mResource.strings.bConfirm,
            style: app.mResource.fonts.bWhite16,
            height: 50,
            function: () async {
              app.mApp.node.unfocus();
              if (app.mApp.input.textControl.text.length < 13) {
                app.mApp.buildAlertDialog(context, header: app.mResource.strings.aInvalidNumber, text: app.mResource.strings.eInvalidNumber);
                return;
              }
              FocusScope.of(context).unfocus();
              app.mApp.auth.setPhoneNumber(app.mApp.input.textControl.text.replaceAll(RegExp(r'[^0-9]'), ''));
              app.mApp.input.clearAll();
              await app.mOverlay.overlayOn();
              CollectionReference invitationsRef = FirebaseFirestore.instance.collection('invitations');
              List emailExists = await FirebaseAuth.instance.fetchSignInMethodsForEmail(app.mApp.auth.phoneNumber + "@exye.com");
              if (emailExists.isNotEmpty) {
                app.mApp.buildAlertDialog(context, header: app.mResource.strings.aAccountExists, text: app.mResource.strings.eAccountExists);
                await app.mOverlay.overlayOff();
                return;
              }
              QuerySnapshot snapshot = await invitationsRef.where('target', isEqualTo: app.mApp.auth.phoneNumber).get();
              if (snapshot.docs.isEmpty) {
                app.mApp.buildActionDialog(
                  context,
                  app.mResource.strings.aNoInvitation,
                  app.mResource.strings.eNoInvitation,
                  action: () {
                    //save number
                  },
                  label1: app.mResource.strings.bLeaveNumber,
                  label2: app.mResource.strings.bPass,
                );
                await app.mOverlay.overlayOff();
                return;
              }
              app.mApp.input.clearAll();
              app.mApp.input.setActive(1);
              try {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+82 ' + app.mApp.auth.phoneNumber,
                  verificationCompleted: (PhoneAuthCredential cred) async {
                    app.mApp.input.setText(cred.smsCode ?? "000000", index: 1);
                  },
                  verificationFailed: (FirebaseAuthException e) async {
                    print(e);
                    await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aVerifyFailed, text: app.mResource.strings.eVerifyFailed);
                    await app.mOverlay.overlayOff();
                    app.mPage.prevPage();
                    return;
                  },
                  codeSent: (String verificationId, int? resendToken) async {
                    app.mApp.auth.setVerificationId(verificationId);
                    if (resendToken != null) {
                      app.mApp.auth.setResendToken(resendToken);
                    }
                    await next();
                    await app.mOverlay.overlayOff();
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              }
              catch (error) {
                print(error);
                await app.mOverlay.overlayOff();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildPage2 () {
    return Column(
      children: [
        CustomHeaderInactive(app.mResource.strings.hSignUp2),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.center,
                child: CustomPasswordInput(
                  1,
                  key: UniqueKey(),
                ),
              ),
              buildNextButton(
                text: app.mResource.strings.bResend,
                function: () async {
                  await app.mOverlay.overlayOn();
                  app.mApp.input.clearAll();
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+82 ' + app.mApp.auth.phoneNumber,
                    forceResendingToken: app.mApp.auth.resendToken,
                    verificationCompleted: (PhoneAuthCredential cred) async {
                      app.mApp.input.setText(cred.smsCode ?? "000000", index: 1);
                      await app.mOverlay.overlayOff();
                    },
                    verificationFailed: (FirebaseAuthException e) async {
                      await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aVerifyFailed, text: app.mResource.strings.eVerifyFailed);
                      await app.mOverlay.overlayOff();
                      app.mPage.prevPage();
                      return;
                    },
                    codeSent: (String verificationId, int? resendToken) async {
                      app.mApp.auth.setVerificationId(verificationId);
                      if (resendToken != null) {
                        app.mApp.auth.setResendToken(resendToken);
                      }
                      await app.mOverlay.overlayOff();
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: CustomKeyboard(
            keyCount: 12,
            columns: 3,
            height: (MediaQuery.of(context).size.width - 40) * 0.8,
            width: MediaQuery.of(context).size.width - 40,
            keys: app.mResource.strings.numberKeys,
            maxLength: 6,
            moreFunction: () {
              changeState();
            },
            fullFunction: () async {
              app.mApp.auth.setCodeSMS(app.mApp.input.texts[1]);
              try {
                await FirebaseAuth.instance.signInWithCredential(
                  PhoneAuthProvider.credential(
                    verificationId: app.mApp.auth.verificationId,
                    smsCode: app.mApp.auth.codeSMS,
                  ),
                );
                app.mApp.input.clearAll();
                next();
                await FirebaseAuth.instance.signOut();
              }
              catch (error) {
                await app.mApp.buildAlertDialog(context, header: "인증 실패", text: "인증코드가 틀렸습니다.");
                await prev();
                await app.mOverlay.overlayOff();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildPage3 () {
    return Column(
      children: [
        CustomHeaderIndicator(app.mResource.strings.hSignUp3, 1),
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: CustomBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: CustomTerms(termsState),
            ),
          ),
        ),
        CustomFooterToLanding(
          button: CustomHybridButton(
            image: app.mResource.images.bCheckFilled,
            text: app.mResource.strings.bConfirm,
            style: app.mResource.fonts.bWhite16,
            height: 50,
            function: () async {
              if (termsState.agreed[1] && termsState.agreed[2]) {
                app.mApp.input.setActive(1);
                app.mApp.input.clearAll();
                app.mApp.input.setHide();
                next();
              }
              else {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aTermsAgree, text: app.mResource.strings.eTermsAgree);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildPage4 () {
    return Column(
      children: [
        CustomHeaderIndicator(app.mResource.strings.hSignUp4, 2),
        Expanded(
          child: Container(),
        ),
        CustomPasswordInput(1, key: UniqueKey(),),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: CustomTextButton(
            text: app.mApp.input.show ? app.mResource.strings.bHide : app.mResource.strings.bShow,
            style: app.mResource.fonts.bold16,
            width: 180,
            height: 50,
            function: () {
              setState(() {
                app.mApp.input.toggleShow();
              });
            },
            colourPressed: app.mResource.colours.buttonLight,
            colourUnpressed: app.mResource.colours.buttonLight,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
          child: CustomKeyboard(
            keyCount: 12,
            columns: 3,
            height: (MediaQuery.of(context).size.width - 40) * 0.8,
            width: MediaQuery.of(context).size.width - 40,
            keys: app.mResource.strings.numberKeys,
            maxLength: 6,
            moreFunction: () {
              changeState();
            },
            fullFunction: () {
              app.mApp.auth.setPassword(app.mApp.input.texts[1]);
              app.mApp.input.setHide();
              app.mApp.input.setActive(2);
              next();
            },
          ),
        ),
      ],
    );
  }

  Widget buildPage4b () {
    return Column(
      children: [
        CustomHeaderIndicator(app.mResource.strings.hSignUp4b, 2),
        Expanded(
          child: Container(),
        ),
        CustomPasswordInput(2, key: UniqueKey(),),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: CustomTextButton(
            text: app.mApp.input.show ? app.mResource.strings.bHide : app.mResource.strings.bShow,
            style: app.mResource.fonts.bold16,
            width: 180,
            height: 50,
            function: () {
              setState(() {
                app.mApp.input.toggleShow();
              });
            },
            colourPressed: app.mResource.colours.buttonLight,
            colourUnpressed: app.mResource.colours.buttonLight,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
          child: CustomKeyboard(
            keyCount: 12,
            columns: 3,
            height: (MediaQuery.of(context).size.width - 40) * 0.8,
            width: MediaQuery.of(context).size.width - 40,
            keys: app.mResource.strings.numberKeys,
            maxLength: 6,
            moreFunction: () {
              changeState();
            },
            fullFunction: () async {
              if (app.mApp.auth.password == app.mApp.input.texts[2]) {

                next();
                app.mApp.input.clearAll();
                app.mApp.input.setActive(-1);
                app.mApp.input.setShow();
              }
              else {
                app.mApp.input.clearAll();
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aPasswordMatch, text: app.mResource.strings.ePasswordMatch);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildPage5 () {
    return Column(
      children: [
        CustomHeaderIndicator(app.mResource.strings.hSignUp5, 3),
        Expanded(
          child: CustomSurvey(surveyState),
        ),
        CustomFooterNoExit(
          button2: CustomHybridButton2(
            image: app.mResource.images.bNextWhite,
            text: app.mResource.strings.bNext,
            style: app.mResource.fonts.bWhite16,
            height: 50,
            function: () async {
              surveyState.name = app.mApp.input.controls[0].text;
              if (app.mApp.input.controls[0].text == "") {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aFillIn, text: app.mResource.strings.eFillIn);
                return;
              }
              if (surveyState.gender == "") {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aFillIn, text: app.mResource.strings.eFillIn);
                return;
              }
              if (surveyState.age == -1) {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aFillIn, text: app.mResource.strings.eFillIn);
                return;
              }
              app.mApp.input.setActive(-1);
              app.mApp.input.clearAll();
              next();
            },
          ),
        ),
      ],
    );
  }

  Widget buildPage5a () {
    return Column(
      children: [
        CustomHeaderIndicator(app.mResource.strings.hSignUp6, 3),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(app.mResource.strings.pInvitation3, style: app.mResource.fonts.headerLight,),
        ),
        Container(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(app.mResource.strings.pInvitation4, style: app.mResource.fonts.base,),
        ),
        Container(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
        Expanded(
          child: CustomAddressSurvey(surveyState),
        ),
        CustomFooterNoExit(
          button1: CustomHybridButton(
            image: app.mResource.images.bPrev,
            text: app.mResource.strings.bPrev,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () {
              app.mApp.input.setText(surveyState.name, index: 0);
              setState(() {
                prev();
              });
            },
            colourUnpressed: app.mResource.colours.buttonLight,
            colourPressed: app.mResource.colours.buttonLight,
          ),
          button2: CustomHybridButton2(
            image: app.mResource.images.bNextWhite,
            text: app.mResource.strings.bNext,
            style: app.mResource.fonts.bWhite16,
            height: 50,
            function: () async {
              if (app.mApp.input.controls[2].text == "") {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aAddress, text: app.mResource.strings.eDetailedAddress);
                return;
              }
              if (app.mApp.input.controls[1].text == "") {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aAddress, text: app.mResource.strings.eAddress);
                return;
              }
              surveyState.address = app.mApp.input.texts[1];
              surveyState.addressDetails = app.mApp.input.controls[2].text;

              app.mApp.input.setActive(-1);
              app.mApp.input.clearAll();
              next();
            },
          ),
        ),

      ],
    );
  }

  Widget buildPage5b () {
    return Column(
      children: [
        CustomHeaderIndicator(app.mResource.strings.hSignUp5, 4),
        Expanded(
          child: CustomBodySurvey(surveyState),
        ),
        CustomFooterNoExit(
          button1: CustomHybridButton(
            image: app.mResource.images.bPrev,
            text: app.mResource.strings.bPrev,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () {
              app.mApp.input.setText(surveyState.address, index: 1);
              app.mApp.input.setText(surveyState.addressDetails, index: 2);
              setState(() {
                prev();
              });
            },
            colourUnpressed: app.mResource.colours.buttonLight,
            colourPressed: app.mResource.colours.buttonLight,
          ),
          button2: CustomHybridButton2(
            image: app.mResource.images.bNextWhite,
            text: app.mResource.strings.bNext,
            style: app.mResource.fonts.bWhite16,
            height: 50,
            function: () async {
              if (app.mApp.input.controls[2].text == "") {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aFillIn, text: app.mResource.strings.eFillIn);
                return;
              }
              if (app.mApp.input.controls[1].text == "") {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aFillIn, text: app.mResource.strings.eFillIn);
                return;
              }
              surveyState.height = int.parse(app.mApp.input.texts[1]);
              surveyState.weight = int.parse(app.mApp.input.texts[2]);

              app.mApp.input.setActive(-1);
              app.mApp.input.clearAll();
              next();
            },
          ),
        ),

      ],
    );
  }

  Widget buildPage6 () {
    return Column(
      children: [
        CustomHeaderIndicator(app.mResource.strings.hSignUp7, 5),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          alignment: Alignment.centerLeft,
          child: Text(app.mResource.strings.hBrands, style: app.mResource.fonts.bold,),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Text(app.mResource.strings.pBrands, style: app.mResource.fonts.base,),
        ),
        Expanded(
          child: CustomBrandsSurvey(brandsState),
        ),
        CustomFooterNoExit(
          button1: CustomHybridButton(
            image: app.mResource.images.bPrev,
            text: app.mResource.strings.bPrev,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () {
              app.mApp.input.setText(surveyState.height.toString(), index: 1);
              app.mApp.input.setText(surveyState.weight.toString(), index: 2);
              setState(() {
                prev();
              });
            },
            colourUnpressed: app.mResource.colours.buttonLight,
            colourPressed: app.mResource.colours.buttonLight,
          ),
          button2: CustomTextButton(
            text: app.mResource.strings.bSignUpComplete,
            style: app.mResource.fonts.bold16,
            height: 50,
            function: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: app.mApp.auth.phoneNumber + "@exye.com",
                  password: app.mApp.auth.password,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aWeakPassword, text: app.mResource.strings.eWeakPassword);
                }
                else if (e.code == 'email-already-in-use') {
                  await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aAccountExists, text: app.mResource.strings.eAccountExists);
                }
              } catch (e) {
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aGenericError, text: e.toString());
              }

              if (FirebaseAuth.instance.currentUser != null) {
                CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

                await usersRef.doc(app.mApp.auth.phoneNumber).set({
                  "name": surveyState.name,
                  "uid": FirebaseAuth.instance.currentUser!.uid,
                  "phoneNumber": app.mApp.auth.phoneNumber,
                  "address": surveyState.address,
                  "addressDetails": surveyState.addressDetails,
                  "age": app.mResource.strings.ages[surveyState.age],
                  "gender": surveyState.gender,
                  "height": surveyState.height,
                  "weight": surveyState.weight,
                  "joinDate": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
                  "userName": "",
                  "email": "",
                  "invitations": 3,
                  "stage": 0,
                  "cart": [],
                  "cartSizes": [],
                });

                app.mApp.input.clearAll();
                app.mApp.input.setActive(-1);
                app.mApp.input.setShow();
                app.mPage.newPage(const HomePage());
              }
              else {
                app.mApp.input.clearAll();
                app.mApp.input.setActive(-1);
                app.mApp.input.setShow();
                app.mPage.newPage(const LandingPage());
                await app.mApp.buildAlertDialog(context, header: app.mResource.strings.aSignUpFail, text: app.mResource.strings.eSignUpFail);
              }
            },
          ),
        ),

      ],
    );
  }

  Widget buildNextButton ({required Function function, String? text}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      alignment: Alignment.center,
      child: CustomTextButton(
        text: text ?? app.mResource.strings.bNext,
        style: app.mResource.fonts.bWhite16,
        height: 50,
        function: () {
          function();
        },
      ),
    );
  }
}
