import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../utils/components/rounded_button.dart';

class DepToBosa extends StatefulWidget {
  const DepToBosa({Key? key}) : super(key: key);

  @override
  State<DepToBosa> createState() => _DepToBosaState();
}

class _DepToBosaState extends State<DepToBosa> {

  TextEditingController amountController = TextEditingController();
  int amount = 0;

  late bool isLoading = false;

  String? destAcc;

  List<String> bosaAccs = ["Deposit Contribution", "Share Capital", "Junior Savings", "Holiday Savings"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MPESA to BOSA',
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
                child: DropdownButton(
                  isExpanded: true,
                  value: destAcc,
                  hint: const Text("Select Bosa Account", style: TextStyle(fontFamily: "ubuntu"),),
                  items: bosaAccs.map((bosaAccsTypeOne) {
                    return DropdownMenuItem(
                      value: bosaAccsTypeOne,
                      child: Text(bosaAccsTypeOne, style: const TextStyle(fontFamily: "ubuntu"),),
                    );
                  }).toList(),
                  onChanged: (value) {
                    destAcc = value.toString();
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
              RoundedButton(
                  text: "Deposit Money",
                  press: (){
                    showAlertDialog(context);
                  }
              )
            ]
        ),
      ),
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
      onPressed: () {
        depositMoney(destAcc.toString());
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to deposit Ksh. ${amountController.text} to ${destAcc.toString()}?",
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
