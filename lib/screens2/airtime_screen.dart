import 'dart:async';
import 'dart:convert';
import 'package:united_women_mobile/Screens/success_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/components/rounded_button.dart';

class AirtimePage extends StatefulWidget{
  static const String idScreen = "airtimescreen";
  @override
  _AirtimePageState createState() => _AirtimePageState();
}

class _AirtimePageState extends State<AirtimePage> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  int amount = 0;

  bool isLoading = false;

  String? destAcc;
  String? phoneNo;
  late String message;
  bool? error;
  List data = List<String>.empty();

  List<String> bosaAccs = ["Safaricom", "Airtel", "Telkom"];

  List<String> phone = ["My Phone"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Airtime Purchase",
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
                  child: DropdownButton(
                    isExpanded: true,
                    value: destAcc,
                    hint: const Text("Select Service Provider", style: TextStyle(fontFamily: "Brand-Regular"),),
                    items: bosaAccs.map((destAccOne) {
                      return DropdownMenuItem(
                        value: destAccOne,
                        child: Text(destAccOne, style: const TextStyle(fontFamily: "Brand-Regular"),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      destAcc = value.toString();
                      _getStateList();
                    },
                  ),
              ),
                const SizedBox(height: 10,),
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    value: phoneNo,
                    hint: const Text("Select Phone Number to buy", style: TextStyle(fontFamily: "Brand-Regular"),),
                    items: phone.map((destAccOne) {
                      return DropdownMenuItem(
                        value: destAccOne,
                        child: Text(destAccOne, style: const TextStyle(fontFamily: "Brand-Regular"),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      phoneNo = value.toString();
                      _getStateList();
                    },
                  ),
                ),
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
                            hint: const Text('Select FOSA Account', style: TextStyle(fontFamily: "Brand-Regular"),),
                            onChanged: (String? newValue) {
                              setState(() {
                                _myState = newValue!;
                                _getStateList();
                              });
                            },
                            items: statesList?.map((item) {
                              return DropdownMenuItem(
                                value: item['AccountNumber'].toString(),
                                child: Text(item['Account_Type'], style: const TextStyle(fontFamily: "Brand-Regular"),),
                              );
                            }).toList() ??
                                [],
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
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
                  text: "Purchase Airtime",
                  press: () {
                    purchaseAirtime();
                  },
                ),
              ]
          ),
        )
    );
  }
  List? statesList;
  String? _myState;

  String fosaAccsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetSourceAccounts';
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
        purchaseAirtime();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to buy airtime worth Ksh. ${int.parse(amountController.text)}?",
        style: const TextStyle(fontFamily: "Brand Bold"),),
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

  purchaseAirtime() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "accFrom": "",
      "amount": amountController.text
    };

    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/AirtimePurchase"),
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
      if(context.mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Success()));
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
        content: Text("${res['Description']}", style: const TextStyle(fontFamily: "Brand Bold"),),
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


