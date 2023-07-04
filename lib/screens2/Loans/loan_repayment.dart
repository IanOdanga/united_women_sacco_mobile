import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/storage.dart';
import '../../constants.dart';
import '../../utils/components/rounded_button.dart';
import '../success_screen.dart';

class LoanRepayment2 extends StatefulWidget{
  static const String idScreen = "cashwithdrawal";
  _LoanRepayment2State createState() => _LoanRepayment2State();
}
class _LoanRepayment2State extends State<LoanRepayment2> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController periodController = TextEditingController();

  final SecureStorage storage = SecureStorage();
  int amount = 0;
  int period = 0;

  bool isLoading = false;

  String? destAcc;

  @override
  void initState() {
    _getStateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Loan Repayment",
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Brand Bold",
            ),
          ),
          backgroundColor: const Color(0xFF1cb1df),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        //child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _myState,
                            iconSize: 30,
                            icon: (null),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: const Text('Select Loan', style: TextStyle(fontFamily: "Brand-Regular"),),
                            onChanged: (String? newValue) {
                              setState(() {
                                _myState = newValue!;
                                _getStateList();
                              });
                            },
                            items: statesList?.map((item) {
                              return DropdownMenuItem(
                                value: item['loan_no'].toString(),
                                child: Text(item['loan_name'], style: const TextStyle(fontFamily: "Brand-Regular"),),
                              );
                            }).toList() ??
                                [],
                          ),
                        ),

                      ),
                    ],
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
                        fontFamily: "Brand-Regular"
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 30.0,),
                RoundedButton(
                    text: "Repay Loan",
                    press: (){
                      showAlertDialog(context);
                    }
                )
              ]
          ),
        )
    );
  }

  List? statesList;
  String? _myState;

  String fosaAccsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetLoans';
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
        statesList = data['loanslist'];
      });
    });

    return data.toString();
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

        if(context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SuccessPage()));
        }
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


}


