import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_women_mobile/screens/success_screen.dart';

import '../constants.dart';
import '../utils/components/rounded_button.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({Key? key}) : super(key: key);

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  int amount = 0;
  String? destAcc;
  String? sourceAcc;
  String? phoneNo;
  bool isLoading = false;

  @override
  void initState() {
    _getFosaAccs();
    super.initState();
  }

  List<String> providers = ["Safaricom", "Airtel", "Telkom"];
  List<String> phone = ["My Phone"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Airtime Purchase",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Brand Bold",
            ),
          ),
          backgroundColor: Constants.kAccentColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
              children: <Widget>[
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    value: sourceAcc,
                    hint: const Text("Select Service Provider", style: TextStyle(fontFamily: "ubuntu"),),
                    items: providers.map((destAccOne) {
                      return DropdownMenuItem(
                        value: destAccOne,
                        child: Text(destAccOne, style: const TextStyle(fontFamily: "ubuntu"),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      sourceAcc = value as String;
                      _getFosaAccs();
                      setState(() {
                        sourceAcc;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    value: phoneNo,
                    hint: const Text("Select Phone Number to buy", style: TextStyle(fontFamily: "ubuntu"),),
                    items: phone.map((destAccOne) {
                      return DropdownMenuItem(
                        value: destAccOne,
                        child: Text(destAccOne, style: const TextStyle(fontFamily: "ubuntu"),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      phoneNo = value as String;
                      _getFosaAccs();
                      setState(() {
                        phoneNo;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10,),
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
                            value: _myAccs,
                            iconSize: 30,
                            icon: (null),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: const Text('Select FOSA Account', style: TextStyle(fontFamily: "Brand-Regular"),),
                            onChanged: (String? newValue) {
                              setState(() {
                                _myAccs = newValue!;
                                _getFosaAccs();
                                //print(_myAccs);
                              });
                            },
                            items: fosaAccs?.map((item) {
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
                const SizedBox(height: 1.0,),
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
                  text: "Purchase Airtime",
                  press: () {
                    showAlertDialog(context);
                  },
                ),
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
            message: 'Purchasing...',
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

        purchaseAirtime();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to purchase airtime worth Ksh. ${amountController.text} from ${_myAccs.toString()} to your phone?",
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

  List? fosaAccs;
  String? _myAccs;

  String fosaAccsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetWSS';
  Future<String> _getFosaAccs() async {
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
        fosaAccs = data['accounts'];
      });
    });

    return data.toString();
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
    //print(response.body);
    if (response.statusCode == 200) {

      if(context.mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Success()));
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
