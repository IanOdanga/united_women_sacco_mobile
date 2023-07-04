import 'package:flutter/material.dart';
import 'package:united_women_mobile/utils/components/text_field_container.dart';

import '../../../constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.phone,
    required this.onChanged, required TextEditingController controller, required TextInputType keyboardType, required TextStyle hintStyle, required FormFieldValidator validator
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Constants.kPrimaryColor,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontFamily: "ubuntu"),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class RoundInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.mail,
    required this.onChanged, required TextEditingController controller, required TextInputType keyboardType, required TextStyle hintStyle, required FormFieldValidator validator
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          /* icon: Icon(
            icon,
            color: Constants.kPrimaryColor,
          ), */
          hintText: hintText,
          hintStyle: const TextStyle(fontFamily: "Brand-Regular"),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class PhoneInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const PhoneInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.phone,
    required this.onChanged, required TextEditingController controller, required TextInputType keyboardType, required TextStyle hintStyle, required FormFieldValidator validator
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Constants.kPrimaryColor,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontFamily: "Brand-Regular"),
          border: InputBorder.none,
        ),
      ),
    );
  }
}