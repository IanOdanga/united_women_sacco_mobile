import 'package:flutter/material.dart';
import '../constants.dart';

class DefaultButton extends StatelessWidget {
  final String? btnText;
  final VoidCallback? onPressed;
  const DefaultButton({
    Key? key, this.btnText, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.kPrimaryColor,
          shadowColor: Constants.kTransparent,
          padding: const EdgeInsets.symmetric(vertical: Constants.kLessPadding),
          elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.kShape)),
        ),
        onPressed: onPressed,
        child: Text(btnText?.toUpperCase() ?? ''),
      ),
    );
  }
}