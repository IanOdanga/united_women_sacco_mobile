import 'dart:async';
import 'dart:convert';
import 'package:united_women_mobile/screens/home_screen.dart';
import 'package:united_women_mobile/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  const PinCodeVerificationScreen(this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(Constants.otpGifImage),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontFamily: "Brand Bold", fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: const TextStyle(color: Colors.black54,fontFamily: "ubuntu", fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Code must be 6 digits";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        //print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        //print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        //print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54,fontFamily: "Brand-Regular", fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () {
                        //getToken();
                        getToken();
                      },
                      child: const Text(
                        "RESEND",
                        style: TextStyle(
                            color: Color(0xFF1cb1df),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                decoration: BoxDecoration(
                    color: Constants.kPrimaryColor,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Constants.kPrimaryColor,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Constants.kPrimaryColor,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        //progressDialog();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                        setState(
                              () {
                            hasError = false;
                          },
                        );
                      }
                    },
                    child: Center(
                        child: Text(
                          "VERIFY".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Brand Bold"
                          ),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                        child: const Text("Clear"),
                        onPressed: () {
                          textEditingController.clear();
                        },
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  progressDialog() async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context, type: ProgressDialogType.normal,
        isDismissible: true,
        showLogs: true);
    pr.style(
        message: 'Verifying Sacco Membership...',
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

    verifyCode(textEditingController.text);
  }

  verifyCode(String verificationCode) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "verification_code": verificationCode
    };
    prefs.setString('Verification Code', verificationCode);
    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/VerifyCode"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    setState(() {
      isLoading=true;
    });
    print(response.body);
    if (response.statusCode == 200) {
      login();
      getMemberInfo();

    } else {
      if(context.mounted) {
        showCodeDialog(context);
      }
    }

  }

  login() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    final code = prefs.getString('Verification Code') ?? '';
    final pinNo = prefs.getString('Password') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "verification_code": code,
      "pin_no": pinNo
    };

    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/Login"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    setState(() {
      isLoading=true;
    });
    //print(response.body);
    if (response.statusCode == 200) {

      if(context.mounted) {
        successDialog(context);
      }
      getMemberInfo();
      if(context.mounted) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                  color: const Color(0xFF295147),
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

  showCodeDialog(BuildContext context) {
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
                          "Could not verify code!",
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