import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class MyLoanGuarantors extends StatefulWidget {
  const MyLoanGuarantors({Key? key}) : super(key: key);

  @override
  State<MyLoanGuarantors> createState() => _MyLoanGuarantorsState();
}

class _MyLoanGuarantorsState extends State<MyLoanGuarantors> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("My Loan Guarantors",
            style: TextStyle(
                fontFamily: "Brand Bold",
                color: Colors.white
            ),
          ),
          backgroundColor: Constants.menuColor,
        ),
        body: FutureBuilder(
            future: getGuarantors(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> map = json.decode(snapshot.data);
              final data = map['guarantorshiplist'];

              List accounts = [];
              data.forEach((element) {
                accounts.add(data);
              });
              return Container(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final account = accounts[index];

                    return ListTile(
                      title: Text(accounts[index][index]['Name'], style: const TextStyle(fontFamily: "Brand Bold")),
                      subtitle: Text(accounts[index][index]['loan_no'], style: const TextStyle(fontFamily: "Brand-Regular")),
                      trailing: Text(
                        accounts[index][index]['guarantorship_amount'].toString(), style: const TextStyle(color: Colors.green, fontFamily: "Brand Bold"),),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: accounts.length,
                ),
              );
            }
        )
    );
  }

  String url = 'https://suresms.co.ke:4242/mobileapi/api/LoanGuarantors';
  getGuarantors({bool isRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final mobileNo = prefs.getString('telephone') ?? '';
    final token = prefs.getString('Token') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    final response = await http.post(Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );
    print(response.body);
    if (response.statusCode == 200) {

      //final data = jsonDecode(response.body);

      //Map<String,dynamic>res=jsonDecode(response.body);

      return response.body;

    }
    else {
      Map<String,dynamic>res=jsonDecode(response.body);
      //Fluttertoast.showToast(msg: "${res['Description']}");
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC72C41),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 48,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Oh snap!!",
                              style: TextStyle(fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: "ubuntu",),
                            ),
                            const Spacer(),
                            Text(
                              "${res['Description']}",
                              style: const TextStyle(fontSize: 12.0,
                                  color: Colors.white,
                                  fontFamily: "ubuntu"),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                    child: SvgPicture.asset("assets/icons/bubbles.svg",
                      height: 48,
                      width: 40,
                      color: const Color(0xFF801336),
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  left: 0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/fail.svg",
                        height: 40,
                      ),
                      Positioned(
                        top: 10,
                        child: SvgPicture.asset(
                          "assets/icons/close.svg",
                          height: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }
    }

    return response.body;
  }
}
