import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/firebase/firebase_auth.dart';
import 'package:firebase_authentication/screens/screen_login.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late User _currentUser;
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              size: 60,
            ),
            const SizedBox(height: 15),
            Text(
              'hi, ${_currentUser.displayName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Signed in as ${_currentUser.email!}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _currentUser.emailVerified
                    ? const Text('Email Verified',
                        style: TextStyle(fontSize: 15, color: Colors.green))
                    : const Text(
                        'Email not verified',
                        style: TextStyle(fontSize: 15),
                      ),
                //Button
                const SizedBox(width: 20),
                _isSendingVerification
                    ? const CircularProgressIndicator()
                    : const SizedBox(width: 20),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _isSendingVerification = true;
                    });
                    await _currentUser.sendEmailVerification();
                    setState(() {
                      _isSendingVerification = false;
                    });
                  },
                  child: const Text(
                    'Verify Email',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      User? user = await FireAuth.refreshUser(_currentUser);
                      if (user != null) {
                        setState(() {
                          _currentUser = user;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.refresh,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            _isSigningOut
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const ScreenLogin(),
                      ));
                    },
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 15),
                    ))
          ],
        ),
      )),
    );
  }
}
