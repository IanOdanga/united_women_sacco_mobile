import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:united_women_mobile/screens2/success_screen.dart';
import '../../constants.dart';

class DepToBosa2 extends StatefulWidget{
  static const String idScreen = "deposits";
  @override
  _DepToBosa2State createState() => _DepToBosa2State();
}


class _DepToBosa2State extends State<DepToBosa2>{

  TextEditingController amountController = TextEditingController();
  int amount = 0;

  late bool isLoading = false;

  String? destAcc;

  List<String> bosaAccs = ["Deposit Contribution", "Share Capital"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MPESA to BOSA',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Brand Bold",
          ),
        ),
        backgroundColor: Constants.menuColor,
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
                        "Deposit Money",
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
      ),
    );
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
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
      onPressed: () async {
        ProgressDialog pr = ProgressDialog(context);
        pr = ProgressDialog(context, type: ProgressDialogType.normal,
            isDismissible: true,
            showLogs: true);
        pr.style(
            message: 'Depositing...',
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
        "Are you sure you want to deposit Ksh. ${amountController.text} to ${destAcc.toString()}?",
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