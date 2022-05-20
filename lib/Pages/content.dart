import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  final String state;
  const Content(this.state, {Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void initState () {
    super.initState();
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    app.mPage.initialise(widget.state);
    app.mOverlay.initialise();
    app.mApp.input.initialise();
    app.mData.getTermsPDF();
    app.mData.getPolicyPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildPage(),
        buildOverlay(),
      ],
    );
  }

  Widget buildPage () {
    return SafeArea(
      child: app.mPage.pageNavObj!,
    );
  }

  Widget buildOverlay () {
    return app.mOverlay.overlayObj!;
  }
}
