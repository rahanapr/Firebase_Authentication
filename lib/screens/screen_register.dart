import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/firebase/firebase_auth.dart';
import 'package:firebase_authentication/firebase/validator.dart';
import 'package:firebase_authentication/screens/screen_home.dart';
import 'package:flutter/material.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({Key? key}) : super(key: key);

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _registerFormKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.flutter_dash,
                    size: 100,
                  ),
                  const SizedBox(height: 10),
                  //welcome Text
                  const Text(
                    'Hi, There',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create your account for Login',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  //email textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _userNameController,
                            focusNode: _focusName,
                            validator: (value) =>
                                Validator.validateName(userName: value!),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                hintText: 'User Name'),
                          ),
                          //password textfield
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _focusEmail,
                            validator: (value) =>
                                Validator.validateEmail(email: value!),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                hintText: 'Email'),
                          ),
                          //password textfield
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _focusPassword,
                            validator: (value) =>
                                Validator.validatePassword(password: value!),
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                hintText: 'Password'),
                          ),
                          const SizedBox(height: 20),
                          //Button
                          _isProcessing
                              ? const CircularProgressIndicator()
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  width: MediaQuery.of(context).size.width * .8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });
                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        User? user = await FireAuth
                                            .registerUsingEmailPassword(
                                          userName: _userNameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                        setState(() {
                                          _isProcessing = false;
                                        });
                                        if (user != null) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ScreenHome(user: user),
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
