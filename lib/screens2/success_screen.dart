import 'package:flutter/material.dart';
import 'package:united_women_mobile/screens2/home_screen.dart';

import '../constants.dart';
import '../widget/default_button.dart';
import '../widget/empty_section.dart';
import '../widget/subtitle.dart';

class SuccessPage extends StatefulWidget {
  SuccessPage({Key? key}) : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptySection(
            emptyImg: Constants.success,
            emptyMsg: 'Successful !!',
          ),
          const SubTitle(
            subTitleText: 'Your payment was done successfully',
          ),
          DefaultButton(
            btnText: 'Ok',
            onPressed: () =>
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
                    (Route route) => false,),
                ),
              ]
            ),
          );
  }
}