import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants.dart';
import '../../utils/components/rounded_button.dart';

class DepToLoan extends StatefulWidget {
  const DepToLoan({Key? key}) : super(key: key);

  @override
  State<DepToLoan> createState() => _DepToLoanState();
}

class _DepToLoanState extends State<DepToLoan> {

  TextEditingController amountController = TextEditingController();
  int amount = 0;

  late bool isLoading = false;

  String? destAcc;

  @override
  void initState() {
    _getLoanAccsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MPESA to LOAN',
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Brand Bold",
            ),
          ),
          backgroundColor: Constants.kAccentColor,
        ),
        backgroundColor: Colors.white,
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
                            value: _loanAccs,
                            iconSize: 30,
                            icon: (null),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: const Text('Select Loan', style: TextStyle(fontFamily: "Brand-Regular"),),
                            onChanged: (String? newValue) {
                              setState(() {
                                _loanAccs = newValue!;
                                _getLoanAccsList();
                                //print(_loanAccs);
                              });
                            },
                            items: statesList?.map((item) {
                              return DropdownMenuItem(
                                value: item['loan_no'].toString(),
                                child: Text(item['loan_name'], style: const TextStyle(fontFamily: "ubuntu"),),
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
                    text: "Deposit Money",
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
  String? _loanAccs;

  String fosaAccsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetLoans';
  Future<String> _getLoanAccsList() async {
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
      onPressed: () {
        Navigator.pop(context);
        depositMoney(_loanAccs.toString());
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to deposit Ksh. ${amountController.text} to ${_loanAccs.toString()} ?",
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

  depositMoney(String accTo) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "amount": int.parse(amountController.text),
      "acc_to": accTo
    };

    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/Deposits"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    setState(() {
      isLoading=false;
    });
    //print(response.body);
    if (response.statusCode == 200) {

      Map<String,dynamic>res=jsonDecode(response.body);

      Widget okButton = TextButton(
        child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
        onPressed:  () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Request received", style: TextStyle(fontFamily: "Brand Bold"),),
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
