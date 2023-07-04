import 'package:flutter/material.dart';
import '../constants.dart';
import 'Deposits/dep_to_bosa.dart';
import 'Deposits/dep_to_loan.dart';

class DepositsPage extends StatefulWidget {
  const DepositsPage({Key? key}) : super(key: key);

  @override
  State<DepositsPage> createState() => _DepositsPageState();
}

class _DepositsPageState extends State<DepositsPage> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DepToBosa2()));
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DepToBosa2()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DepToLoan2()));
                },
                child: ListTile(
                  //leading: const Icon(Icons.car_rental),
                  title: const Text('Deposit to Loan', style: TextStyle(fontFamily: "ubuntu", fontWeight: FontWeight.w600),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DepToLoan2()));
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
