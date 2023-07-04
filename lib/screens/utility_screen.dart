import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:united_women_mobile/screens/success_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../utils/components/rounded_button.dart';

class UtilityScreen extends StatefulWidget {
  const UtilityScreen({Key? key}) : super(key: key);

  @override
  State<UtilityScreen> createState() => _UtilityScreenState();
}

class _UtilityScreenState extends State<UtilityScreen> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  List<String> bosaAccs = ["KPLC", "Water Bill", "Internet", "DSTV"];

  List<String> phone = ["My Phone"];

  List<String> fosaAccs = ["Current Account", "Ordinary Savings", "Holiday Account"];

  String? destAcc;
  String? sourceAcc;
  String? phoneNo;
  late int amount;

  @override
  void initState() {
    _getAccountsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Utility Payments",
            style: TextStyle(
                fontFamily: "Brand Bold",
                color: Colors.white
            ),),
          backgroundColor: Constants.kSecondaryColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
              children: <Widget>[
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    value: destAcc,
                    hint: const Text("Select Utility", style: TextStyle(fontFamily: "ubuntu"),),
                    items: bosaAccs.map((destAccOne) {
                      return DropdownMenuItem(
                        value: destAccOne,
                        child: Text(destAccOne, style: const TextStyle(fontFamily: "ubuntu"),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      destAcc = value as String;
                      setState(() {
                        destAcc;
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
                            hint: const Text('Select Account', style: TextStyle(fontFamily: "Brand-Regular"),),
                            onChanged: (String? newValue) {
                              setState(() {
                                _myAccs = newValue!;
                                _getAccountsList();
                                //print(_myAccs);
                              });
                            },
                            items: accsList?.map((item) {
                              return DropdownMenuItem(
                                value: item['account_number'].toString(),
                                child: Text(item['account_name'], style: const TextStyle(fontFamily: "ubuntu"),),
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
                  text: "Pay",
                  press: () {
                    showAlertDialog(context);
                  },
                ),
              ]
          ),
        )
    );
  }

  List? accsList;
  String? _myAccs;

  String fosaAccsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetWSS';
  Future<String> _getAccountsList() async {
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
        accsList = data['accounts'];
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

        if(context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Success()));
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to pay for ${destAcc.toString()} worth Ksh. ${amountController.text} from your ${sourceAcc.toString()}?",
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
