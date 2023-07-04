import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  static const String idScreen = "profile";
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile',
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Brand Bold",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: getMemberInfo(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            //print(snapshot.data);
            Map<String, dynamic> map = json.decode(snapshot.data);
            final data = map;
            return Column(
              children: <Widget>[
                Container(
                    height: 150.0,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black,Colors.blueAccent]
                        )
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50.0,
                              child: Image.asset(
                                'assets/images/user_icon.png',
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(data['Name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Brand Bold",
                                )),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    )
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: 300.00,
                  color: const Color(0xffFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        'Personal Information',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status
                                        ? _getEditIcon()
                                        : Container(),
                                  ],
                                )
                              ],
                            )),
                        const Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        'Name',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.0,
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: data['Name'],
                                      hintStyle: const TextStyle(
                                        fontSize: 11.0,
                                      ),
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,

                                  ),
                                ),
                              ],
                            )),
                        const Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        'Mobile',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.0,
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: data['Telephone'],
                                      hintStyle: const TextStyle(
                                        fontSize: 11.0,
                                      ),
                                    ),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
                        const Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              ],
                            )),
                        const Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              ],
                            )),
                        !_status ? _getActionButtons() : Container(),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        )
    );
  }

  getMemberInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };

    final  response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/GetmemberInfo"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      /*Map<String,dynamic>res=jsonDecode(response.body);

      final data = jsonDecode(response.body);*/

      return response.body;

    } else {
      Fluttertoast.showToast(msg: "Please try again!");
    }
    return response.body;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      textStyle: const TextStyle(color: Colors.white, fontFamily: "ubuntu"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    child: const Text("Save"),
                  )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      textStyle: const TextStyle(color: Colors.white, fontFamily: "ubuntu"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    child: const Text("Cancel"),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.cyan.shade200,
        radius: 14.0,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

}
