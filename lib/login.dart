// ignore_for_file: sort_child_properties_last, prefer_const_constructors, duplicate_ignore
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key, required String title}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  LoginController loginController = Get.put(LoginController());
  @override
  // ignore: duplicate_ignore
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore, duplicate_ignore
    return Container(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
          // image: const DecorationImage(
          //     image: AssetImage('assets/login.png'), fit: BoxFit.cover),
          ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 110),
              // ignore: prefer_const_constructors
              child: Text(
                'Welcome to\nIntekhab',
                style: const TextStyle(color: Colors.black, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: loginController.emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  // ignore: prefer_const_constructors
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: const TextStyle(color: Colors.black),
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: loginController.passwordController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: const TextStyle(color: Colors.black),
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 1.0),
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18,
                                      ),
                                    )),
                              )),
                          SizedBox(
                            height: 1,
                          ),
                          MaterialButton(
                            onPressed: () {
                              loginController.loginWithEmail();
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // ignore: prefer_const_constructors
                              Text(
                                'Sign in',
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFF373f51),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      loginController.loginWithEmail();
                                    },
                                    // ignore: prefer_const_constructors
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              ),
                            ],
                          ),
                          // ignore: prefer_const_constructors
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'register');
                                },
                                child: RichText(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    text: TextSpan(children: [
                                  const TextSpan(
                                      text: 'Don\'t have an account? ',
                                      style: TextStyle(
                                          color: Color(0xff4c505b),
                                          fontSize: 18)),
                                  const TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18))
                                ])),
                                // ignore: sort_child_properties_last
                                // child: const Text(
                                //   'Sign Up',
                                //   textAlign: TextAlign.left,
                                //   style: TextStyle(
                                //       decoration: TextDecoration.underline,
                                //       color: Color(0xff4c505b),
                                //       fontSize: 18),
                                // ),
                                style: const ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
