import 'package:united_women_mobile/constants.dart';
import 'package:flutter/material.dart';
import '../widget/default_button.dart';
import '../widget/empty_section.dart';
import '../widget/subtitle.dart';
import 'home_screen.dart';

class Success extends StatefulWidget {
  Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
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
                    MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()),
                        (Route route) => false,),
            ),
          ]
      ),
    );
  }
}