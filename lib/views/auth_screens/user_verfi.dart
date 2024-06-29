import 'dart:async';

import 'package:ai_app/user_auth/firebase_auth_implementatio/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationPage extends StatefulWidget {
  final User user;

  EmailVerificationPage({required this.user});

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isEmailVerified = false;
  bool _isResending = false;
  bool _isCancelling = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      setState(() {
        _isEmailVerified = true;
      });
      _timer.cancel();
      // Show loader for 1 second before navigating to the next screen
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacementNamed(
          context, "/lib/views/auth_screens/login_page.dart");
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
    });
    try {
      await _authService.sendEmailVerification(widget.user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email resent.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend verification email.')),
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _cancelVerification() {
    setState(() {
      _isCancelling = true;
    });
    Navigator.pushReplacementNamed(
        context, "/lib/views/auth_screens/signup_page.dart");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Email Verification',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _isEmailVerified
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Verify Your Email Address',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'A verification email has been sent to ${widget.user.email}. Please check your email and click on the verification link to activate your account.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      if (_isResending)
                        CircularProgressIndicator()
                      else
                        ElevatedButton.icon(
                          onPressed: _resendVerificationEmail,
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Resend Verification Email',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      SizedBox(height: 20),
                      if (_isCancelling)
                        CircularProgressIndicator(
                          color: Colors.white,
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: _cancelVerification,
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
