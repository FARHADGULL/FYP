import 'package:evm_app/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  RegisterationController registerationController =
      Get.put(RegisterationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 30,
      ),
      body: Stack(
        children: [
          Container(
            // ignore: prefer_const_constructors
            padding: EdgeInsets.only(left: 35),
            // ignore: prefer_const_constructors
            child: Text(
              'Create\nAccount',
              style: const TextStyle(color: Colors.black, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.23),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 70),
                    child: Column(
                      children: [
                        TextField(
                          controller: registerationController.nameController,
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
                                // ignore: prefer_const_constructors
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Name",
                              //image: 'user.svg',
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
                          controller: registerationController.emailController,
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
                          controller:
                              registerationController.passwordController,
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
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ignore: prefer_const_constructors
                            Text(
                              'Sign Up',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    registerationController.registerWithEmail();
                                  },
                                  // ignore: prefer_const_constructors
                                  icon: Icon(
                                    Icons.arrow_forward,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'login');
                              },
                              style: const ButtonStyle(),
                              child: RichText(
                                  text: const TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Sign In',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          decoration:
                                              TextDecoration.underline)),
                                ],
                              )),
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
    );
  }
}
