import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../utils/components/rounded_button.dart';


class LoanCalculator2 extends StatefulWidget {
  const LoanCalculator2({Key? key}) : super(key: key);

  @override
  State<LoanCalculator2> createState() => _LoanCalculator2State();
}

class _LoanCalculator2State extends State<LoanCalculator2> {

  final TextEditingController _pp = TextEditingController();
  final TextEditingController _dp = TextEditingController();
  final TextEditingController _fa = TextEditingController();
  final TextEditingController _ir = TextEditingController();
  final TextEditingController _t = TextEditingController();
  String _conPP = "";
  String _conDP = "";
  double downPayment = 0;

  void _showDialog(BuildContext? ctx) {
// check the value is not null or empty before show up
    if (_pp.text.isEmpty ||
        _dp.text.isEmpty ||
        _ir.text.isEmpty ||
        _t.text.isEmpty) {
      // show the error message snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // calculate the down payment

    double principal = double.parse(_pp.text.replaceAll(',', '')) -
        double.parse(_dp.text.replaceAll(',', ''));

    double monthly = principal / int.parse(_t.text);
    double interest = (principal * double.parse(_ir.text)) / 100;
    double totalInterest = interest * int.parse(_t.text);

    // bottome sheet
    showModalBottomSheet(
        context: ctx!,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Loan Amount", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text(_pp.text.replaceAll(',', ''), style: const TextStyle(fontFamily: "ubuntu"),),
                ),
                ListTile(
                  title: const Text("Down Payment", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text(_dp.text.replaceAll(',', ''), style: const TextStyle(fontFamily: "ubuntu"),),
                ),
                ListTile(
                  title: const Text("Principal", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text(principal.toStringAsFixed(0), style: const TextStyle(fontFamily: "ubuntu"),),
                ),
                ListTile(
                  title: const Text("Interest Rate", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text("${_ir.text}%", style: const TextStyle(fontFamily: "ubuntu"),),
                ),
                ListTile(
                  title: const Text("Loan Period", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text(_t.text, style: const TextStyle(fontFamily: "ubuntu"),),
                ),
                ListTile(
                  title: const Text("Payment per month", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text(monthly.toStringAsFixed(0), style: const TextStyle(fontFamily: "ubuntu"),),
                ),
                ListTile(
                  title: const Text("interest per month", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text(interest.toStringAsFixed(0), style: const TextStyle(fontFamily: "ubuntu"),),
                ),
                /*ListTile(
                  title: const Text("Total Interest", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing:
                  Text(totalInterest.toStringAsFixed(0), style: const TextStyle(fontFamily: "ubuntu"),),
                ),*/
                ListTile(
                  title: const Text("Total Payment", style: TextStyle(fontFamily: "ubuntu"),),
                  trailing: Text(
                    (principal + interest).toStringAsFixed(0), style: const TextStyle(fontFamily: "ubuntu"),),
                ),
              ],
            ),
          );
        });
  }

  List<String> loanProducts = ["Emergency Loan", "Development Loan", "Car Loan"];
  String? loanProds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Loan Calculator",
          style: TextStyle(
              fontFamily: "Brand Bold",
              color: Colors.white
          ),
        ),
        backgroundColor: Constants.menuColor,
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(Constants.kDefaultPadding),
            child: RoundedButton(
              press: () => _showDialog(context),
              text: "Calculate",
            ),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.kDefaultPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: Constants.kDefaultPadding,
          ),
          Container(
            child: DropdownButton(
              isExpanded: true,
              value: loanProds,
              hint: const Text("Select Loan Product", style: TextStyle(fontFamily: "ubuntu"),),
              items: loanProducts.map((destAccOne) {
                return DropdownMenuItem(
                  value: destAccOne,
                  child: Text(destAccOne, style: const TextStyle(fontFamily: "ubuntu"),),
                );
              }).toList(),
              onChanged: (value) {
                loanProds = value as String;
                setState(() {
                  loanProds;
                });
              },
            ),
          ),
          const SizedBox(
            height: Constants.kDefaultPadding,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _pp,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              labelText: 'Enter Loan Amount',
              suffixText: "KES",
              labelStyle: TextStyle(fontFamily: "ubuntu"),
              suffixStyle: TextStyle(fontFamily: "ubuntu"),),
            onChanged: (String? string) {
              if (string!.isEmpty) {
                // clear data
                _dp.clear();
                _fa.clear();
                _ir.clear();
                _t.clear();
                setState(() {
                  downPayment = 0.0;
                });
                return;
              }
              _conPP = string.replaceAll(',', '');
              string = string.replaceAll(',', '');
              _pp.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length));
              if (_conPP != "" && _conDP != "") {
                String total =
                (int.parse(_conPP) - int.parse(_conDP)).toString();
                _fa.value = TextEditingValue(
                    text: total,
                    selection: TextSelection.collapsed(offset: total.length));
              }
            },
          ),
          const SizedBox(
            height: Constants.kDefaultPadding,
          ),
          Text("Down Payment (${downPayment.toStringAsFixed(0)}%)", style: const TextStyle(fontFamily: "ubuntu"),),
          Slider(
              value: downPayment,
              min: 0,
              max: 100,
              divisions: 100,
              label: "${downPayment.toStringAsFixed(0)}%",
              onChanged: (double? value) {
                int pp = int.parse(_pp.text.replaceAll(',', ''));
                int dp = (pp * value! / 100).round();
                setState(() {
                  downPayment = value;
                  _dp.text = dp.toString().replaceAll(',', '');
                });
              }),
          const SizedBox(
            height: Constants.kDefaultPadding,
          ),
          TextField(
            controller: _dp,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              labelText: 'Down Payment',
              labelStyle: TextStyle(fontFamily: "ubuntu"),
            ),
            onChanged: (String? string) {
              if (string!.isEmpty) return;
              if (int.parse(string.replaceAll(',', '')) > int.parse(_conPP)) {
                _dp.text = _conPP;
                return;
              }
              _conDP = string.replaceAll(',', '');
              string = string.replaceAll(',', '');
              _dp.value = TextEditingValue(
                  text: string!,
                  selection: TextSelection.collapsed(offset: string.length));
              // check if the down payment is not empty
              if (_conDP != "") {
                // check if the loan amount is not empty
                if (_conPP != "") {
                  // calculate the percentage of down payment
                  double dp = int.parse(_conDP) / int.parse(_conPP) * 100;
                  setState(() {
                    downPayment = dp;
                  });
                } else {
                  // check if the loan amount is empty
                  String total =
                  (int.parse(_conDP) / downPayment * 100).toString();
                  _conPP = total.replaceAll('.', '');
                  _pp.text = total.replaceAll('.', '');
                }
              }
            },
          ),
          const SizedBox(
            height: Constants.kDefaultPadding,
          ),
          TextField(
            controller: _ir,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Interest Rate',
                labelStyle: TextStyle(fontFamily: "ubuntu"),
                suffixIcon: Icon(Icons.percent_outlined)),
          ),
          const SizedBox(
            height: Constants.kDefaultPadding,
          ),
          TextField(
            controller: _t,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                labelText: 'Loan Term (Month)',
                labelStyle: TextStyle(fontFamily: "ubuntu"),
                suffixIcon: Icon(Icons.calendar_month_outlined)),
          )
        ]),
      ),
    );
  }
}
