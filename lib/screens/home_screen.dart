import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_women_mobile/screens/profile_screen.dart';
import 'package:united_women_mobile/screens/settings_screen.dart';
import 'package:united_women_mobile/screens/transactions_screen.dart';
import 'package:united_women_mobile/screens/utility_screen.dart';
import 'package:united_women_mobile/screens/withdrawal_screen.dart';
import '../animations/fade_animation.dart';
import '../constants.dart';
import '../model/member_model.dart';
import '../model/transactions_model.dart';
import 'accounts_screen.dart';
import 'airtime_screen.dart';
import 'balance_enquiry_screen.dart';
import 'deposits_screen.dart';
import 'funds_transfer_screen.dart';
import 'loans_screen.dart';
import 'login_screen.dart';
import 'mini_statements_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  final _advancedDrawerController = AdvancedDrawerController();
  List<Transactions> listModel = [];
  Transactions? transactionsList;
  bool isLoading = false;

  AccountsResponseModel? accountModel;

  String? memberName;
  double? accBalance;
  String? accNumber;

  void init() {
    super.initState();
    getMemberInfo();
  }

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Constants.kAccentColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          width: 32.0,
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 128.0,
                    height: 32.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 64.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/user_icon.png',
                    ),
                  ),
                  const Text("Welcome user",
                      style: TextStyle(
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                        fontFamily: "Brand Bold",
                      )),
                  const Spacer(),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                    },
                    leading: const Icon(Icons.account_circle_rounded, color: Colors.black87,),
                    title: const Text('Profile',
                      style: TextStyle(
                        fontFamily: "ubuntu",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsScreen()));
                    },
                    leading: const Icon(Icons.receipt_long_rounded, color: Colors.black87),
                    title: const Text('Recent Transactions',
                      style: TextStyle(
                        fontFamily: "ubuntu",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    },
                    leading: const Icon(Icons.settings, color: Colors.black87),
                    title: const Text('Settings',
                      style: TextStyle(
                        fontFamily: "ubuntu",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.logout, color: Colors.black87),
                      title: Text('Logout',
                        style: TextStyle(
                          fontFamily: "ubuntu",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Dashboard', style: TextStyle(color: Colors.black, fontFamily: "Brand Bold"),),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.black, size: 30,),
            )
          ],
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                const SizedBox(height: 30,),
                FadeAnimation(1.2, Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(0, 4),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hi $memberName' , style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 15.0),
                                const Text("Welcome back",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "ubuntu",
                                    )),
                                const SizedBox(height: 5,),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.kPrimaryColor,
                            shadowColor: Colors.black,
                            elevation: 15,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          child: const Center(child: Text('View Accounts', style: TextStyle(color: Colors.white, fontFamily: "ubuntu", fontWeight: FontWeight.bold, fontSize: 18),)),
                        )
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 20,),

                Container(
                  padding: const EdgeInsets.all(13),
                  height: (MediaQuery
                      .of(context)
                      .size
                      .width) *
                      (8 / 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Text('Services',
                            style: TextStyle(
                                fontSize: 21,
                                fontFamily: 'Brand Bold'
                            ),
                            textAlign: TextAlign
                                .center,
                          ),
                        ],
                      ),

                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 0.7,
                          children: [
                            serviceWidgetBalance(
                                "balance", "Balance\nEnquiry"),
                            serviceWidgetMini(
                                "statements",
                                "Mini\nStatements"),
                            serviceWidgetLoans(
                                "loans", "Loans"),
                            serviceWidgetDeposits(
                                "receiveMoney",
                                "Mpesa\nDeposits"),
                            serviceWidgetWithdraw(
                                "phone",
                                "Withdraw\nCash"),
                            serviceWidgetUtility(
                                "electricity",
                                "Utility\nPayments"),
                            serviceWidgetAirtime(
                                "tag",
                                "Purchase\nAirtime"),
                          ],
                        ),
                      ),
                    ],
                  ),),
                const SizedBox(height: 20,),
                FadeAnimation(1.3, Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Transactions', style: TextStyle(fontSize: 20, fontFamily: "ubuntu", fontWeight: FontWeight.bold),),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsScreen()));
                          },
                          child: const Text('View all', style: TextStyle(fontFamily: "ubuntu"),)
                      )
                    ],
                  ),
                )),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        final nDataList = listModel[index];
                        return FadeAnimation((1.0 + index) / 4, workerContainer(nDataList.statementlist!.postingDate.toString(), nDataList.statementlist!.description.toString(), nDataList.statementlist?.amount as double));
                      }
                  ),
                ),
                const SizedBox(height: 150,),
              ]
          ),
        ),
      ),
    );
  }

  workerContainer(String name, String job, double rating) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 3.5,
        child: Container(
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade200,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontFamily: "ubuntu", fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text(job, style: const TextStyle(fontSize: 15, fontFamily: "ubuntu"),)
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(rating.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    // const Icon(Icons.star, color: Colors.orange, size: 20,)
                  ],
                )
              ]
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  Widget services (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Services', style: TextStyle(
                fontSize: 21,
                fontFamily: 'Brand Bold'
            ),),
          ],
        ),

        Expanded(
          child:GridView.count(crossAxisCount: 4,
            childAspectRatio: 0.7,
            children: [
              serviceWidgetBalance("balance", "Balance\nEnquiry"),
              serviceWidgetMini("statements", "Mini\nStatements"),
              serviceWidgetLoans("loans", "Loans"),
              serviceWidgetDeposits("receiveMoney", "Mpesa\nDeposits"),
              serviceWidgetWithdraw("phone", "Withdraw\nCash"),
              serviceWidgetUtility("electricity", "Utility\nPayments"),
              serviceWidgetAirtime("tag", "Purchase\nAirtime"),
            ],
          ),
        ),
      ],
    );
  }

  Column serviceWidgetFunds(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FundsTransferScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=2x&id=acdL4BH8D6iv&format=png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetDeposits(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DepositsScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=2x&id=dgRoj6JD1ESE&format=png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetWithdraw(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WithdrawalScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=2x&id=Dd4nRd1t1lKu&format=png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetUtility(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UtilityScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=2x&id=lEMPkL3DwtiB&format=png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetAirtime(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AirtimeScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=2x&id=2616IUXNFkHK&format=png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetMini(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MiniStatementScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://img.icons8.com/?size=2x&id=ushmkLPUgXcE&format=png'),
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetLoans(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoansScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=2x&id=gti9tAcZR0pp&format=png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetBalance(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BalanceScreen()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('https://img.icons8.com/?size=2x&id=13016&format=png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: "ubuntu",
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  getMemberInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    //print(data);
    final  response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/GetmemberInfo"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );
    //final resp = jsonDecode(response.body);
    //print(response.body);
    if (response.statusCode == 200) {
      //print(response.body);

      Map<String,dynamic>res=jsonDecode(response.body);
      //print(res['Name']);
      prefs.setString('Name', res['Name']);
      prefs.setString('AccNo', res['AccountNumber']);
      prefs.setString('Account_Type', res['Account_Type']);
      prefs.setDouble('Account_Balance', res['Account_Balance']);

      setState(() {
        memberName = res['Name'];
        accBalance = res['Account_Balance'];
        accNumber = res['AccountNumber'];
      });

      final resp = json.decode(response.body);
      var data = resp["statementlist"] as List;
      accountModel = AccountsResponseModel.fromJson(resp);
      print(accountModel!.memberNo);
      return AccountsResponseModel.fromJson(resp);

    } else if (response.statusCode == 401) {
      if(context.mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
    else {
      Map<String,dynamic>res=jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }
    return response.body;
  }

  String miniStmtUrl = 'https://suresms.co.ke:4242/mobileapi/api/MiniStatements';
  Future<void> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };

    final res = await http.post(
      Uri.parse(miniStmtUrl),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        for(Map<String, dynamic> index in data){
          listModel.add(Transactions.fromJson(index));
        }
        isLoading = false;
      });
    }
  }
}