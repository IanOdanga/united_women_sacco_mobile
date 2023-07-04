import 'package:flutter/material.dart';

import '../constants.dart';
import '../model/balances.dart';

class BalanceEnquiry extends StatefulWidget {
  const BalanceEnquiry({Key? key}) : super(key: key);

  @override
  State<BalanceEnquiry> createState() => _BalanceEnquiryState();
}

class _BalanceEnquiryState extends State<BalanceEnquiry> {

  List<Balance> balances = [
    Balance( 'Deposit Contribution', 153340.0),
    Balance('Share Capital', 100000.0),
    Balance('Current Account', 20340.0),
    Balance('Holiday Fund', 30000.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Account Balance",
            style: TextStyle(
                fontFamily: "Brand Bold",
                color: Colors.white
            ),
          ),
          backgroundColor: Constants.menuColor,
        ),
        body: ListView.separated(
          itemCount: balances.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(balances[index].accountType, style: const TextStyle(fontFamily: "ubuntu", fontWeight: FontWeight.bold)),
              trailing: Text(balances[index].amount.toString(), style: const TextStyle(fontFamily: "ubuntu")),
            );
          },
          separatorBuilder: (context, index) => const Divider(),

        )
    );
  }
}
