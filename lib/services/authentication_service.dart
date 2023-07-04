import 'dart:convert';
import 'package:united_women_mobile/services/storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/token_model.dart';


getToken() async {
  final prefs = await SharedPreferences.getInstance();

  final username = prefs.getString('Username') ?? '';
  final password = prefs.getString('Password') ?? '';
  final response= await http.get(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/GetToken"),
      headers: {
        "Username": username,
        "Password": password,
        "Accept": "application/json"
      }
  );
  if (response.statusCode == 200) {
    if (response.body.isNotEmpty)
    {
      Map<String, dynamic>res = jsonDecode(response.body);
      String? authToken = res['Token'];
      final SecureStorage secureStorage = SecureStorage();
      secureStorage.writeSecureToken('Token', authToken!);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('Token', res['Token']);

      final mobileNo = prefs.getString('telephone') ?? '';
      sendVerificationCode(mobileNo);

    } else {
      Map<String, dynamic>res = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }
  } else {
    Fluttertoast.showToast(msg: "Please try again!");
  }
  return TokenModelResponse.fromJson(json.decode(response.body));
}

sendVerificationCode(mobileNo) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('Token') ?? '';
  Map data = {
    "mobile_no": mobileNo
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

  final SecureStorage secureStorage = SecureStorage();
  secureStorage.writeSecureToken('Telephone', mobileNo);

  if (response.statusCode == 200) {
    //Map<String,dynamic>res=jsonDecode(response.body);

  } else {
    Map<String,dynamic>res=jsonDecode(response.body);
    Fluttertoast.showToast(msg: "${res['Description']}");
  }
}

getMemberInfo() async {
  const name ="";
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
    //Map<String,dynamic>res=jsonDecode(response.body);
    //final data = jsonDecode(response.body);
    prefs.setString('Name', name);
    return response.body;

  } else {
    Fluttertoast.showToast(msg: "Please try again!");
  }
  return response.body;
}