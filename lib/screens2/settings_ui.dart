import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class SettingsScreen2 extends StatefulWidget {
  const SettingsScreen2({Key? key}) : super(key: key);

  @override
  State<SettingsScreen2> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen2> {

  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = false;

  onChangedFunction1 (bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
    });
  }
  onChangedFunction2 (bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }
  onChangedFunction3 (bool newValue3) {
    setState(() {
      valNotify2 = newValue3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Brand Bold"
            )
        ),
        backgroundColor: Constants.menuColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 40,),
            const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Constants.kPrimaryColor,
                ),
                SizedBox(width: 10,),
                Text("Account", style: TextStyle(fontFamily: "ubuntu",
                    fontSize: 22,
                    fontWeight: FontWeight.bold),),
              ],
            ),
            const Divider(height: 20, thickness: 1,),
            const SizedBox(height: 10,),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Content Settings"),
            buildAccountOption(context, "Social"),
            buildAccountOption(context, "Language"),
            buildAccountOption(context, "Privacy & Security"),
            const SizedBox(height: 40,),
            const Row(
              children: [
                Icon(Icons.volume_up_outlined, color: Constants.kPrimaryColor,),
                SizedBox(width: 10,),
                Text("Notifications", style: TextStyle(fontFamily: "ubuntu", fontSize: 22, fontWeight: FontWeight.bold),)
              ],
            ),
            const Divider(height: 20, thickness: 1,),
            const SizedBox(height: 10,),
            buildNotificationOption("Theme Dark", valNotify1, onChangedFunction1),
            buildNotificationOption("Account Active", valNotify2, onChangedFunction2),
            buildNotificationOption("Opportunity", valNotify3, onChangedFunction3),
            const SizedBox(height: 50,),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                onPressed: () {},
                child: const Text("SIGN OUT", style: TextStyle(fontFamily: "ubuntu", fontSize: 16, letterSpacing: 2.2, color: Colors.black87),),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding buildNotificationOption(String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontFamily: "ubuntu", fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[600]),),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, style: const TextStyle(fontFamily: "ubuntu")),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Option 1"),
                  Text("Option 2"),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close")
                )
              ],
            );
          });
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey [600]
                )),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey)
              ],
            )
        )
    );
  }
}
