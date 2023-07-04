import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:united_women_mobile/Screens/funds_transfer_screen.dart';
import 'package:united_women_mobile/screens2/accounts_screen.dart';
import 'package:united_women_mobile/screens2/airtime_screen.dart';
import 'package:united_women_mobile/screens2/deposits_screen.dart';
import 'package:united_women_mobile/screens2/loans_screen.dart';
import 'package:united_women_mobile/screens2/profile_screen.dart';
import 'package:united_women_mobile/screens2/settings_ui.dart';
import 'package:united_women_mobile/screens2/statements.dart';
import 'package:united_women_mobile/screens2/transactions_screen.dart';
import '../Screens/login_screen.dart';
import '../animations/fade_animation.dart';
import '../constants.dart';
import '../model/transactions.dart';
import 'balance_enquiry.dart';
import 'cash_withdrawals_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Transactions> transactions = [
    Transactions('Jan 10, 2023', 'Deposit', 100.0),
    Transactions('Feb 12, 2023','Withdrawal', -5000.0),
    Transactions('Feb 13, 2023', 'Deposit to loan', 25000.0),
    Transactions('Feb 22, 2023', 'Mobile Loan', 10000.0),
    Transactions('April 16, 2023','Funds Transfer', 500.0),
    Transactions('May 13, 2023', 'Withdrawal', -1700.0),
  ];

  final _advancedDrawerController = AdvancedDrawerController();

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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsPage()));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen2()));
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
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                SizedBox(height: 15.0),
                                Text("Welcome back",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "ubuntu",
                                    )),
                                SizedBox(height: 5,),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Constants.kSecondaryColor,
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
                            serviceWidgetFunds(
                                "sendMoney",
                                "Funds\nTransfer"),
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
                            serviceWidgetMini(
                                "statements",
                                "Mini\nStatements"),
                            serviceWidgetLoans(
                                "loans", "Loans"),
                            serviceWidgetBalance(
                                "balance", "Balance\nEnquiry"),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionsPage()));
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
                      itemCount: transactions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FadeAnimation((1.0 + index) / 4, workerContainer(transactions[index].date, transactions[index].transType, transactions[index].amount));
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
              serviceWidgetFunds("sendMoney", "Funds\nTransfer"),
              serviceWidgetDeposits("receiveMoney", "Mpesa\nDeposits"),
              serviceWidgetWithdraw("phone", "Withdraw\nCash"),
              serviceWidgetUtility("electricity", "Utility\nPayments"),
              serviceWidgetAirtime("tag", "Purchase\nAirtime"),
              serviceWidgetMini("statements", "Mini\nStatements"),
              serviceWidgetLoans("loans", "Loans"),
              serviceWidgetBalance("balance", "Balance\nEnquiry"),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DepositsPage()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawalPage()));
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
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const UtilityPayments()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => AirtimePage()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => StatementPage()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoansPage()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BalanceEnquiry()));
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
}
