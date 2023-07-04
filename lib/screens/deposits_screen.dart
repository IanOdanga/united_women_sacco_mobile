import 'package:flutter/material.dart';

import '../constants.dart';
import 'deposits/dep_to_bosa_screen.dart';
import 'deposits/dep_to_loan_screen.dart';

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({Key? key}) : super(key: key);

  @override
  State<DepositsScreen> createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Deposits", style: TextStyle(fontFamily: "Brand Bold"),),
        backgroundColor: Constants.kAccentColor,
      ),
      body: Container(
          child: ListView(
            children: [
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DepToBosa()));
                },
                child: Container(
                  child: ListTile(
                    //leading: const Icon(Icons.car_rental),
                    title: const Text('Deposit to Bosa', style: TextStyle(fontFamily: "ubuntu", fontWeight: FontWeight.w600),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const DepToBosa()));
                            },
                            icon: const Icon(
                              Icons.navigate_next,
                              size: 20.0,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(thickness: 2,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DepToLoan()));
                },
                child: ListTile(
                  //leading: const Icon(Icons.car_rental),
                  title: const Text('Deposit to Loan', style: TextStyle(fontFamily: "ubuntu", fontWeight: FontWeight.w600),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DepToLoan()));
                          },
                          icon: const Icon(
                            Icons.navigate_next,
                            size: 20.0,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
              ),
              const Divider(thickness: 2,)
            ],
          )
      ),
    );
  }
}
