import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../success_screen.dart';

class LoanRepayment extends StatefulWidget {
  const LoanRepayment({Key? key}) : super(key: key);

  @override
  State<LoanRepayment> createState() => _LoanRepaymentState();
}

class _LoanRepaymentState extends State<LoanRepayment> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  int amount = 0;
  String? destAcc;

  List<String> loanAccs = ["Development Loan - 160,000", "Mobile Loan - 15,000", "Salary Advance - 30,000", "Emergency Loan - 60,000"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Loan Repayment",
            style: TextStyle(
                fontFamily: "Brand Bold",
                color: Colors.white
            ),
          ),
          backgroundColor: Constants.menuColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
              children: <Widget>[
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    value: destAcc,
                    hint: const Text("Select Loan", style: TextStyle(fontFamily: "ubuntu"),),
                    items: loanAccs.map((sourceAccOne) {
                      return DropdownMenuItem(
                        value: sourceAccOne,
                        child: Text(sourceAccOne, style: const TextStyle(fontFamily: "ubuntu"),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      print(value);
                      destAcc = value as String;
                      setState(() {
                        destAcc;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                //const SizedBox(height: 1.0,),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    amount = int.parse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "ubuntu"
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 30.0,),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(color: Colors.white, fontFamily: "ubuntu"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                    ),
                    child: Container(
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Repay Loan",
                          style: TextStyle(fontSize: 16.0, fontFamily: "ubuntu", color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: (){
                      showAlertDialog(context);
                    }
                )
              ]
          ),
        )
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () async {
        ProgressDialog pr = ProgressDialog(context);
        pr = ProgressDialog(context, type: ProgressDialogType.normal,
            isDismissible: true,
            showLogs: true);
        pr.style(
            message: 'Transferring...',
            borderRadius: 6.0,
            backgroundColor: Colors.white,
            progressWidget: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Constants.kPrimaryColor),),
            elevation: 10.0,
            insetAnimCurve: Curves.easeInOut,
            progress: 0.0,
            textAlign: TextAlign.center,
            padding: const EdgeInsets.all(15.0),
            maxProgress: 100.0,
            progressTextStyle: const TextStyle(
                color: Colors.black, fontFamily: "ubuntu"),
            messageTextStyle: const TextStyle(
                color: Colors.black, fontFamily: "ubuntu", fontWeight: FontWeight.bold)
        );
        await pr.show();

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Success()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to repay Ksh. ${amountController.text} to your ${destAcc.toString()} ?",
        style: const TextStyle(fontFamily: "ubuntu"),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List? statesList;
  String? _myState;

  String fosaAccsUrl = '';
  Future<String> _getStateList() async {
    final prefs = await SharedPreferences.getInstance();
    final mobileNo = prefs.getString('telephone') ?? '';
    final token = prefs.getString('Token') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    await http.post(Uri.parse(fosaAccsUrl),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    ).then((response) {
      var data = json.decode(response.body);

      //print(data);
      setState(() {
        statesList = data['accounts'];
      });
    });

    return data.toString();
  }

}
