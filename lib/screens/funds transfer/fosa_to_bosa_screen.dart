import 'package:flutter/material.dart';

class FosaToBosa extends StatefulWidget {
  const FosaToBosa({Key? key}) : super(key: key);

  @override
  State<FosaToBosa> createState() => _FosaToBosaState();
}

class _FosaToBosaState extends State<FosaToBosa> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  int amount = 0;
  bool isLoading = false;
  String? destAcc;
  List<String> bosaAccs = ["Deposit Contribution", "Share Capital"];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
