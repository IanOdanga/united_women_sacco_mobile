import 'dart:async';
import 'dart:convert';
import 'package:united_women_mobile/Services/storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../utils/components/rounded_button.dart';

class WithdrawalPage extends StatefulWidget{
  static const String idScreen = "withdraw";
  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  final SecureStorage storage = SecureStorage();

  late int amount;
  String? destAcc;
  late String message;
  bool isLoading = false;

  @override
  void initState() {
    _getStateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cash Withdrawals",
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Brand Bold",
            ),
          ),
          backgroundColor: Constants.kPrimaryColor,
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
                            hint: const Text('Select Account', style: TextStyle(fontFamily: "Brand-Regular"),),
                            onChanged: (String? newValue) {
                              setState(() {
                                _myState = newValue!;
                                _getStateList();
                              });
                            },
                            items: statesList?.map((item) {
                              return DropdownMenuItem(
                                value: item['account_number'].toString(),
                                child: Text(item['account_name'], style: const TextStyle(fontFamily: "Brand-Regular"),),
                              );
                            }).toList() ??
                                [],
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 10,),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    amount = value as int;
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
                    text: "Withdraw",
                    press: () {
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

  String fosaAccsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetWSS';
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

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () {
        withdrawCash();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to withdraw Ksh. ${amountController.text} from ${_myState.toString()}?",
        style: const TextStyle(fontFamily: "Brand-Regular"),),
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

  withdrawCash() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "amount": amountController.text,
      "accFrom": _myState.toString(),
    };

    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/CashWithdrawals"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    setState(() {
      isLoading=false;
    });

    if (response.statusCode == 200) {
      Map<String,dynamic>res=jsonDecode(response.body);

      Widget okButton = TextButton(
        child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
        onPressed:  () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Completed", style: TextStyle(fontFamily: "Brand Bold"),),
        content: Text("${res['Description']}", style: const TextStyle(fontFamily: "ubuntu"),),
        actions: [
          okButton,
        ],
      );

      if(context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

    } else {
      Map<String,dynamic>res=jsonDecode(response.body);

      Widget okButton = TextButton(
        child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
        onPressed:  () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Failed", style: TextStyle(fontFamily: "Brand Bold"),),
        content: Text("${res['Description']}", style: const TextStyle(fontFamily: "ubuntu"),),
        actions: [
          okButton,
        ],
      );

      if(context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    }
  }
}