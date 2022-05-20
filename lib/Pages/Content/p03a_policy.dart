import 'package:exye_app/Widgets/custom_button.dart';
import 'package:exye_app/Widgets/custom_footer.dart';
import 'package:exye_app/Widgets/custom_header.dart';
import 'package:exye_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  late PDFViewController control;
  //PageController control = PageController();
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomHeaderInactive(app.mResource.strings.hTerms),
        Expanded(
          child: buildTerms(),
        ),
        buildButtons(),
      ],
    );
  }

  Widget buildTerms () {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: PDFView(
        filePath: app.mData.policy!.path,
        onViewCreated: (controller) {
          setState(() {
            control = controller;
          });
        },
      ),
    );
  }

  Widget buildButtons () {
    return const CustomFooterPrev();
  }
}
