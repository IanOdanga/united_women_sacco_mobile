import 'package:flutter/material.dart';

import '../animations/fade_animation.dart';
import '../model/services.dart';
import '../utils/components/rounded_login_button.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  List<Services> services = [
    Services('Balance', 'https://img.icons8.com/?size=2x&id=13016&format=png'),
    Services('Statements', 'https://img.icons8.com/?size=2x&id=ushmkLPUgXcE&format=png'),
    Services('Transfer', 'https://img.icons8.com/?size=2x&id=acdL4BH8D6iv&format=png'),
    Services('Loans', 'https://img.icons8.com/?size=2x&id=gti9tAcZR0pp&format=png'),
    Services('Deposit', 'https://img.icons8.com/?size=2x&id=dgRoj6JD1ESE&format=png'),
    Services('Withdraw', 'https://img.icons8.com/?size=2x&id=Dd4nRd1t1lKu&format=png'),
    Services('Utility', 'https://img.icons8.com/?size=2x&id=lEMPkL3DwtiB&format=png'),
    Services('Airtime', 'https://img.icons8.com/?size=2x&id=2616IUXNFkHK&format=png'),
    Services('Accounts', 'https://img.icons8.com/?size=2x&id=0p22VK4M3lWV&format=png'),
  ];

  int selectedService = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 45,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeAnimation((1.0 + index) / 4, serviceContainer(services[index].imageURL, services[index].name, index));
                }
            ),
          ),
          Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80)
                    )
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 45,),
                    FadeAnimation(1.5, Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                        child: Text(
                          'Easy, reliable way to \nmanage your banking needs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            fontFamily: "Brand Bold",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 40,),
                    FadeAnimation(1.5, Container(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Center(
                        child: Text(
                          'Welcome to United Women Sacco M-banking',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 40,),
                    RoundedLoginButton(
                      text: "LOGIN",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedService == index ? Colors.white : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index ? Colors.blue.shade100 : Colors.grey.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image, height: 30),
              const SizedBox(height: 10,),
              Text(name, style: const TextStyle(fontSize: 12, fontFamily: "Brand-Regular"),)
            ]
        ),
      ),
    );
  }
}
