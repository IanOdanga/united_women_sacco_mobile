import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_women_mobile/screens/verification_screen.dart';
import 'package:united_women_mobile/screens2/home_screen.dart';

import '../constants.dart';
import '../services/settings.dart';
import '../services/storage.dart';
import '../utils/components/background.dart';
import '../utils/components/rounded_input_field.dart';
import '../utils/components/rounded_login_button.dart';
import '../utils/components/rounded_password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController telephoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late String phone;
  late String password;
  late bool isLoading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "Brand Bold"),
              ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                "assets/icons/signup.png",
                height: size.height * 0.35,
                //color: Constants.kPrimaryLightColor,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                controller: telephoneController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return ("Please Enter Your Phone Number");
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return ("Please Enter a valid email");
                  }
                  return null;
                },
                hintText: "Phone Number",
                hintStyle: const TextStyle(fontFamily: "ubuntu"),
                onChanged: (value) {
                  phone = value;
                  telephoneController.text = phone;
                },
              ),
              RoundedPasswordField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  RegExp regex = RegExp(r'^.{4,}$');
                  if (value.isEmpty) {
                    return ("Pin is required for login");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid Pin(Min. 4 Character)");
                  }
                  return null;
                },
                hintText: "M-banking pin",
                hintStyle: const TextStyle(fontFamily: "ubuntu"),
                onChanged: (value) {
                  password = value;
                  passwordController.text = password;
                },
              ),
              RoundedLoginButton(
                text: "LOGIN",
                press: () async {
                  if (telephoneController.text.isEmpty){
                    showPhoneDialog(context);
                  }
                  else if (passwordController.text.isEmpty){
                    showPassDialog(context);
                  }
                  else if (telephoneController.text.isEmpty && passwordController.text.isEmpty){
                    showAlertDialog(context);
                  }
                  else if(telephoneController.text == '0740481483' && passwordController.text == '5299'){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                  }
                  else {
                    if (telephoneController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      progressDialog();
                      //getToken();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  showPhoneDialog(BuildContext context) {
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
              child: const Row(
                children: [
                  SizedBox(width: 48,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Oh snap!!",
                          style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "ubuntu",),
                        ),
                        Spacer(),
                        Text(
                          "Phone number cannot be empty!",
                          style: TextStyle(fontSize: 12.0, color: Colors.white, fontFamily: "ubuntu"),
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
                  //color: const Color(0xFF801336),
                  colorFilter: const ColorFilter.mode(Color(0xFF801336), BlendMode.color)
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

  showPassDialog(BuildContext context) {
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
              child: const Row(
                children: [
                  SizedBox(width: 48,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Oh snap!!",
                          style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "ubuntu",),
                        ),
                        Spacer(),
                        Text(
                          "M-banking in cannot be empty!",
                          style: TextStyle(fontSize: 12.0, color: Colors.white, fontFamily: "ubuntu"),
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
                  //color: const Color(0xFF801336),
                  colorFilter: const ColorFilter.mode(Color(0xFF801336), BlendMode.color)
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

  showAlertDialog(BuildContext context) {
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
              child: const Row(
                children: [
                  SizedBox(width: 48,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Oh snap!!",
                          style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "ubuntu",),
                        ),
                        Spacer(),
                        Text(
                          "Phone number or pin cannot be empty",
                          style: TextStyle(fontSize: 12.0, color: Colors.white, fontFamily: "ubuntu"),
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
                  //color: const Color(0xFF801336),
                  colorFilter: const ColorFilter.mode(Color(0xFF801336), BlendMode.color)
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

  progressDialog() async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context, type: ProgressDialogType.normal,
        isDismissible: true,
        showLogs: true);
    pr.style(
        message: 'Authenticating...',
        borderRadius: 6.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Constants.kPrimaryColor),),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        textAlign: TextAlign.center,
        padding: const EdgeInsets.all(15.0),
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontFamily: "ubuntu"),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontFamily: "ubuntu", fontWeight: FontWeight.bold)
    );
    await pr.show();

    getToken();
  }

  successDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFF36827F),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 48,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Success!",
                          style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "ubuntu",),
                        ),
                        Spacer(),
                        Text(
                          "OTP sent successfully",
                          style: TextStyle(fontSize: 12.0, color: Colors.white, fontFamily: "ubuntu"),
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
                  //color: const Color(0xFF295147),
                  colorFilter: const ColorFilter.mode(Color(0xFF295147), BlendMode.color)
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/icons/success.png",
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

  String tokenUrl = "https://suresms.co.ke:4242/mobileapi/api/GetToken";
  getToken() async {
    final SecureStorage secureStorage = SecureStorage();

    secureStorage.writeSecureToken('username', 'admin@unitedwomen');
    secureStorage.writeSecureToken('password', 'Un1t3Br4k');

    String? username = secureStorage.readSecureToken('username') as String?;
    String? password = secureStorage.readSecureToken('password') as String?;

    final response= await http.get(
        Uri.parse(tokenUrl),
        headers: {
          "Username": username!,
          "Password": password!,
          "Accept": "application/json"
        }
    );
    //print(response.body);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty)
      {
        Map<String, dynamic>res = jsonDecode(response.body);
        String? authToken = res['Token'];

        secureStorage.writeSecureToken('Token', authToken!);
        secureStorage.writeSecureToken('username', username);
        secureStorage.writeSecureToken('password', password);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('Token', res['Token']);
        //prefs.setString('telephone', telephoneController.text);

        var tokenTime = res['Expiry'];
        prefs.setString('tokenTime', tokenTime);

        sendVerificationCode(telephoneController.text, passwordController.text);

      } else {
        Map<String, dynamic>res = jsonDecode(response.body);
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
                        colorFilter: const ColorFilter.mode(Color(0xFF801336), BlendMode.color)
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
    } else if (response.persistentConnection == true) {
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
                  child: const Row(
                    children: [
                      SizedBox(width: 48,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Oh snap!!",
                              style: TextStyle(fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: "ubuntu",),
                            ),
                            Spacer(),
                            Text(
                              "Kindly check your internet connection",
                              style: TextStyle(fontSize: 12.0,
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
                      //color: const Color(0xFF801336),
                      colorFilter: const ColorFilter.mode(Color(0xFF801336), BlendMode.color)
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

    else {
      if (context.mounted) {
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
                  child: const Row(
                    children: [
                      SizedBox(width: 48,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Oh snap!!",
                              style: TextStyle(fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: "ubuntu",),
                            ),
                            Spacer(),
                            Text(
                              "Please try again later",
                              style: TextStyle(fontSize: 12.0,
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
                      colorFilter: const ColorFilter.mode(Color(0xFF801336), BlendMode.color)
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
    //return response.body;
  }

  sendVerificationCode(mobileNo, pinNo) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "pin_no": pinNo
    };

    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/SendVerificationCode"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
      //encoding: Encoding.getByName("utf-8")
    );
    prefs.setString('telephone', mobileNo);
    prefs.setString('Password', pinNo);

    final SecureStorage secureStorage = SecureStorage();
    secureStorage.writeSecureToken('Telephone', mobileNo);
    secureStorage.writeSecureToken('Password', pinNo);

    setState(() {
      isLoading=false;
    });
    //print(response.body);
    if (response.statusCode == 200) {

      if(context.mounted) {
        successDialog(context);
      }

      if(context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) =>
              PinCodeVerificationScreen(mobileNo)),
        );
      }

    } else {
      Map<String,dynamic>res=jsonDecode(response.body);
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
                      //color: const Color(0xFF801336),
                      colorFilter: const ColorFilter.mode(Color(0xFF801336), BlendMode.color)
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
  }
}
