import 'package:flutter/material.dart';
import '../constants.dart';
import 'funds transfer/fosa_to_bosa_screen.dart';
import 'funds transfer/fosa_to_fosa_screen.dart';
import 'funds transfer/fosa_to_other_screen.dart';

class FundsTransferScreen extends StatefulWidget {
  const FundsTransferScreen({Key? key}) : super(key: key);

  @override
  State<FundsTransferScreen> createState() => _FundsTransferScreenState();
}

class _FundsTransferScreenState extends State<FundsTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Funds Transfer", style: TextStyle(fontFamily: "Brand Bold"),),
        backgroundColor: Constants.kAccentColor,
      ),
      body: Container(
          child: ListView(
            children: [
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FosaToBosa()));
                },
                child: ListTile(
                  //leading: const Icon(FontAwesomeIcons.rightLeft),
                  title: const Text('Fosa to Bosa', style: TextStyle(fontFamily: "ubuntu", fontWeight: FontWeight.bold),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FosaToBosa()));
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
              const Divider(thickness: 2,),
              ListTile(
                //leading: const Icon(Icons.car_rental),
                title: const Text('Fosa to Fosa', style: TextStyle(fontFamily: "ubuntu", fontWeight: FontWeight.w600),),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FosaToFosa()));
                        },
                        icon: const Icon(
                          Icons.navigate_next,
                          size: 20.0,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              const Divider(thickness: 2,),
              ListTile(
                //leading: const Icon(Icons.car_rental),
                title: const Text('Fosa to Other', style: TextStyle(fontFamily: "ubuntu", fontWeight: FontWeight.w600),),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FosaToOther()));
                        },
                        icon: const Icon(
                          Icons.navigate_next,
                          size: 20.0,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              const Divider(thickness: 2,)
            ],
          )
      ),
    );
  }
}
