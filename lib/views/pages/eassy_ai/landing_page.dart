import 'package:ai_app/views/pages/eassy_ai/home_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  static const String KEYLOGIN = "login";

  bool showAnim = false;
  double top1 = 100;
  double top2 = 300;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1710), () {
      setState(() {
        showAnim = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color(0xFF171717),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                top: top1,
                width: width,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  height: 100,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 5),
                top: top2,
                width: width,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Colors.blue, Colors.green],
                                tileMode: TileMode.clamp,
                              ).createShader(bounds);
                            },
                            child: const Center(
                              child: Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Color.fromRGBO(11, 240, 255, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Text(
                              'Your all in one A.I Assistant',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          AnimatedTextKit(
                            onFinished: () {
                              setState(() {
                                top1 = 300;
                                top2 = 100;
                              });
                            },
                            repeatForever: false,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              RotateAnimatedText(
                                "",
                                rotateOut: false,
                                duration: const Duration(microseconds: 1),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              showAnim
                  ? Positioned(
                      top: height * 0.35,
                      width: width,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        height: 100,
                        child: const Center(
                          child: Text(
                            'MEGAN AI',
                            style: TextStyle(
                              color: Color.fromRGBO(11, 240, 255, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              showAnim
                  ? Positioned(
                      bottom: height * 0.1,
                      left: 20,
                      right: 20,
                      child: SizedBox(
                        height: 50,
                        child: SizedBox(
                          width: width - 40,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 255, 174),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
