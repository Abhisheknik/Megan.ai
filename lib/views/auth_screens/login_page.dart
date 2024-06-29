import 'package:flutter/material.dart';
import 'package:ai_app/Packages/package.dart';
import 'package:ai_app/user_auth/firebase_auth_implementatio/firebase_auth_services.dart';
import 'package:ai_app/views/auth_screens/forget_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key to validate form

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: blackColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Login",
            style: TextStyle(
              fontFamily: regular,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.5,
              color: Colors.white, // Set text color to white
            ),
          ),
          centerTitle: true, // Center the title
          backgroundColor: Colors.transparent, // Make app bar transparent
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), // Adjust the opacity here
                  BlendMode.dstATop,
                ),
                child: Image.asset(
                  igvector3,
                  fit: BoxFit.fitWidth,
                  width: width * 1,
                  height: height * 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: _formKey, // Assign form key to the Form widget
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                        decoration: Inputdeco(),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Border color set to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Border color set to white
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _loginUp,
                        child: Container(
                          width: width * 0.9, // Set button width
                          height: 50, // Set button height
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: _isSigning
                                ? CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Add a sized box for spacing
                      // GestureDetector(
                      //   onTap: _signInWithGoogle,
                      //   child: Container(
                      //     width: width * 0.9, // Set button width
                      //     height: 50, // Set button height
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue, // Button color
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Sign in with Google",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Color.fromARGB(255, 131, 9, 245),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height:
                              5), // Add spacing between "Sign up" and "Forgot Password"
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              // color: Colors.white, // Light purple color
                              // borderRadius: BorderRadius.circular(20),
                              ),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: regular,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration Inputdeco() {
    return InputDecoration(
      labelText: 'Email',
      labelStyle: TextStyle(color: Colors.white, fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            BorderSide(color: Colors.white), // Border color set to white
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            BorderSide(color: Colors.white), // Border color set to white
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }

  void _loginUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSigning = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      User? user = await _auth.signInWithEmailAndPassword(email, password);

      setState(() {
        _isSigning = false;
      });

      if (user != null && user.emailVerified) {
        Navigator.pushReplacementNamed(context, "/lib/views/ai_tool.dart");
      } else if (user != null && !user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email before logging in.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed, please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // void _signInWithGoogle() async {
  //   setState(() {
  //     _isSigning = true;
  //   });

  //   try {
  //     User? user = await _auth.signInWithGoogle();

  //     setState(() {
  //       _isSigning = false;
  //     });

  //     if (user != null) {
  //       print("Google sign-in successful");
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => AiTool(),
  //         ),
  //       );
  //     } else {
  //       print("Google sign-in failed");
  //       _showErrorDialog("Google sign-in failed. Please try again.");
  //     }
  //   } catch (e) {
  //     print("Error signing in with Google: $e");
  //     _showErrorDialog("Google sign-in failed. Please try again.");
  //   }
  // }
}
