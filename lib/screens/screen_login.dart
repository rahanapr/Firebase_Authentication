import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/firebase/firebase_auth.dart';
import 'package:firebase_authentication/firebase/validator.dart';
import 'package:firebase_authentication/screens/screen_home.dart';
import 'package:firebase_authentication/screens/screen_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isProcessing = false;
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ScreenHome(user: user),
      ));
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.flutter_dash,
                            size: 100,
                          ),
                          const SizedBox(height: 10),
                          //welcome Text
                          const Text(
                            'Hello!',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Login to your existing account',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),
                          //email textfield
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    validator: (value) =>
                                        Validator.validateEmail(email: value!),
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        hintText: 'Email'),
                                  ),
                                  //password textfield
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    validator: (value) =>
                                        Validator.validatePassword(
                                            password: value!),
                                    controller: _passwordController,
                                    focusNode: _focusEmail,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        hintText: 'Password'),
                                  ),
                                  const SizedBox(height: 10),
                                  _isProcessing
                                      ? const CircularProgressIndicator()
                                      :
                                      //Button
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .06,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              _focusEmail.unfocus();
                                              _focusPassword.unfocus();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isProcessing = true;
                                                });
                                                User? user = await FireAuth
                                                    .loginUsingEmailPassword(
                                                        email: _emailController
                                                            .text,
                                                        password:
                                                            _passwordController
                                                                .text,
                                                        context: context);
                                                setState(() {
                                                  _isProcessing = false;
                                                });
                                                if (user != null) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                    builder: (context) =>
                                                        ScreenHome(user: user),
                                                  ));
                                                }
                                              }
                                            },
                                            child: const Text(
                                              'Login',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          )),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ScreenRegister()));
                                  },
                                  child: const Text(
                                    'Register Now',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
