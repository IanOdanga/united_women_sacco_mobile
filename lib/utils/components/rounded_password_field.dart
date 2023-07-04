import 'package:flutter/material.dart';
import 'package:united_women_mobile/utils/components/text_field_container.dart';
import '../../../constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged, required String hintText, required TextEditingController controller, required bool obscureText, required TextInputType keyboardType, required String? Function(String value) validator, required TextStyle hintStyle,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: "M-banking pin",
          hintStyle: TextStyle(fontFamily: "ubuntu"),
          icon: Icon(
            Icons.lock,
            color: Constants.kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Constants.kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RoundedConfPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedConfPasswordField({
    Key? key,
    required this.onChanged, required String hintText, required TextEditingController controller, required bool obscureText, required TextInputType keyboardType, required String? Function(String value) validator, required TextStyle hintStyle,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          hintText: "Confirm Password",
          hintStyle: TextStyle(fontFamily: "Brand-Regular"),
          icon: Icon(
            Icons.lock,
            color: Constants.kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Constants.kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}