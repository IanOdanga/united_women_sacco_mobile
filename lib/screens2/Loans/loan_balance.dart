import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanBalances2 extends StatefulWidget {
  static const String idScreen = "loanbalance";
  LoanBalances2({Key? key}) : super(key: key);

  @override
  _LoanBalances2State createState() => _LoanBalances2State();
}

class _LoanBalances2State extends State<LoanBalances2> {

  final formKey = GlobalKey<FormState>();

  final RefreshController refreshController =
  RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Balances',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
                fontFamily: "Brand Bold"
            )
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: getLoans(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Map<String, dynamic> map = json.decode(snapshot.data);
            final data = map['loanslist'];

            List accounts = [];
            data.forEach((element) {
              accounts.add(data);
            });
            return Container(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final account = accounts[index];

                  return ListTile(
                    title: Text(accounts[index][index]['loan_name'], style: const TextStyle(fontFamily: "Brand Bold")),
                    subtitle: Text(accounts[index][index]['loan_no'], style: const TextStyle(fontFamily: "Brand-Regular")),
                    trailing: Text(
                      accounts[index][index]['outstanding_balance'].toString(), style: const TextStyle(color: Colors.green, fontFamily: "Brand Bold"),),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: accounts.length,
              ),
            );
          }
      ),
    );
  }

  String miniStmtUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetLoans';
  getLoans({bool isRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final mobileNo = prefs.getString('telephone') ?? '';
    final token = prefs.getString('Token') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    final response = await http.post(Uri.parse(miniStmtUrl),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200) {

      return response.body;

    }
    else {
      Map<String,dynamic>res=jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }

    return response.body;
  }
}