import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../success_screen.dart';

class MobileLoans extends StatefulWidget {
  const MobileLoans({Key? key}) : super(key: key);

  @override
  State<MobileLoans> createState() => _MobileLoansState();
}

class _MobileLoansState extends State<MobileLoans> {

  TextEditingController textEditingController = TextEditingController();
  TextEditingController periodController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  int amount = 0;
  int period = 0;
  late bool isLoading;
  String? loanType;

  List<String> loanProds = ["Mobile Loan", "Salary Advance", "Cloud Loan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Mobile Loans",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Brand Bold",
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
                    value: loanType,
                    hint: const Text("Select Loan Type", style: TextStyle(fontFamily: "ubuntu"),),
                    items: loanProds.map((loanTypeOne) {
                      return DropdownMenuItem(
                        value: loanTypeOne,
                        child: Text(loanTypeOne, style: const TextStyle(fontFamily: "ubuntu"),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      loanType = value as String;
                      setState(() {
                        loanType;
                      });
                      //_getStateList();
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: periodController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    period = int.parse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Period (in months)',
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
                          "Check Eligibility",
                          style: TextStyle(fontSize: 16.0, fontFamily: "ubuntu", color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: (){
                      progressDialog();
                    }
                )
              ]
          ),
        )
    );
  }

  progressDialog() async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context, type: ProgressDialogType.normal,
        isDismissible: true,
        showLogs: true);
    pr.style(
        message: 'Checking Eligibility...',
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
      showAlertDialog(context);
    }
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
        checkEligibility();
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to borrow ${loanType.toString()} loan for a period of ${periodController.text} months?",
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

  checkEligibility() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "loan_type_code": loanType.toString(),
      "no_of_months": periodController.text
    };

    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/MobileAdvanceEligibility"),
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
      //snackBar("Transaction Successful!");

      Widget okButton = TextButton(
        child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
        onPressed:  () {
          Navigator.pop(context);
          _settingModalBottomSheet(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Qualification", style: TextStyle(fontFamily: "Brand Bold"),),
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

    } else if(response.statusCode != 200){
      Map<String,dynamic>res=jsonDecode(response.body);

      Widget okButton = TextButton(
        child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
        onPressed:  () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Qualification", style: TextStyle(fontFamily: "Brand Bold"),),
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height-100.0,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20), topLeft: Radius.circular(20))
            ),
            child: Wrap(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center
                  , children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                ],),
                /*Container(
                  //padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
                  alignment: Alignment.center,
                  child: const Text("Enter amount",
                      style: TextStyle(
                        fontFamily: "ubuntu",
                        color: Colors.black87,
                      )
                  ),
                ),*/
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.center,
                  child: TextFormField(
                      controller: amountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        labelText: 'Enter Amount',
                        labelStyle: TextStyle(fontFamily: "ubuntu"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                    ),
                    const SizedBox(width: 10,),
                    Text('Borrow Ksh. ${amountController.text}',
                      style: const TextStyle(
                          fontSize: 14, fontFamily: "ubuntu"),),
                    const SizedBox(width: 10,),
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      showAmountDialog(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("Borrow Loan", style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: "ubuntu"),),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
  showAmountDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed:  () {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Success()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text("Are you sure you want to borrow Ksh. ${amountController.text}?", style: const TextStyle(fontFamily: "ubuntu"),),
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
