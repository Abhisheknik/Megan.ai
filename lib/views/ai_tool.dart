import 'dart:async';
import 'dart:ui';

import 'package:ai_app/Packages/package.dart';
import 'package:ai_app/packages/package.dart';
import 'package:ai_app/views/pages/text_finder/text_finder.dart';
import 'package:ai_app/views/pages/text_to_img/texttoimg.dart';
import 'package:ai_app/views/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AiTool extends StatefulWidget {
  const AiTool({Key? key}) : super(key: key);

  @override
  State<AiTool> createState() => _AiToolState();
}

class _AiToolState extends State<AiTool> {
  late String username = "Default Username";
  late String userProfileImage = "";

  @override
  void initState() {
    super.initState();
    _listenToUserData();
  }

  void _listenToUserData() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          FirebaseFirestore.instance
              .collection('sign_data')
              .doc(user.uid)
              .snapshots()
              .listen((DocumentSnapshot snapshot) {
            if (snapshot.exists) {
              setState(() {
                username = snapshot.get('name') ?? "Default Username";
                userProfileImage = snapshot.get('profile_picture') ?? "";
              });
            }
          });
        }
      });
    });
  }

  void updateUserData(String newName, String newProfilePicture) {
    setState(() {
      username = newName;
      userProfileImage = newProfilePicture;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: Text(
          "Hey👋 $username",
          style: TextStyle(
            fontFamily: regular,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => Container(
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff171717),
              border: Border.all(
                color: Color.fromARGB(48, 255, 255, 255),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: userProfileImage.isNotEmpty
                  ? NetworkImage(userProfileImage)
                  : AssetImage(igbot) as ImageProvider<Object>,
            ),
          ),
        ],
      ),
      drawer: HomeScreenDrawer(
        username: username,
        userProfileImage: userProfileImage,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(igvector3),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'How may I help you today?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: semibold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GirdTile(width: width, height: height),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      width: width * 0.9,
                      height: height * 0.08,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Random',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: semibold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GirdTile extends StatelessWidget {
  const GirdTile({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  500), // Adjust the duration as needed
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ChatPage(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(21, 255, 255,
                            255), // Adjust opacity as per your preference
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromARGB(53, 255, 255,
                              255), // Specify the border color here
                          width: 1, // Adjust the border width as needed
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 129, 103, 182)
                                .withOpacity(0.9),
                            spreadRadius: 60,
                            blurRadius: 90,
                            offset: Offset(-180, -20),
                          ),
                        ],
                      ),
                      width: width * 0.6,
                      height: (height * 0.25) + 15,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            right: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  22), // Rounded border with a radius of 22
                              child: Image.asset(
                                img, // Replace with your image URL
                                width: 155, // Increased width
                                height: 155, // Increased height
                                fit: BoxFit.contain,
                              ),
                            ), // Image at top left corner
                          ),
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Text(
                              "ChatGPT",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: semibold,
                                  color: Colors.white),
                            ), // Icon on bottom left corner
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ), // Arrow on bottom right corner
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  500), // Adjust the duration as needed
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ChatPage(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(21, 255, 255,
                            255), // Adjust opacity as per your preference
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromARGB(53, 255, 255,
                              255), // Specify the border color here
                          width: 1, // Adjust the border width as needed
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 129, 103, 182)
                                .withOpacity(0.9),
                            spreadRadius: 60,
                            blurRadius: 90,
                            offset: Offset(-180, -20),
                          ),
                        ],
                      ),
                      width: width * 0.6,
                      height: (height * 0.25) + 15,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            right: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  22), // Rounded border with a radius of 22
                              child: Image.asset(
                                img, // Replace with your image URL
                                width: 155, // Increased width
                                height: 155, // Increased height
                                fit: BoxFit.contain,
                              ),
                            ), // Image at top left corner
                          ),
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Text(
                              "ChatGPT",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: semibold,
                                  color: Colors.white),
                            ), // Icon on bottom left corner
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ), // Arrow on bottom right corner
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  500), // Adjust the duration as needed
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ChatPage(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(21, 255, 255,
                            255), // Adjust opacity as per your preference
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromARGB(53, 255, 255,
                              255), // Specify the border color here
                          width: 1, // Adjust the border width as needed
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 129, 103, 182)
                                .withOpacity(0.9),
                            spreadRadius: 60,
                            blurRadius: 90,
                            offset: Offset(-180, -20),
                          ),
                        ],
                      ),
                      width: width * 0.6,
                      height: (height * 0.25) + 15,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            right: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  22), // Rounded border with a radius of 22
                              child: Image.asset(
                                img, // Replace with your image URL
                                width: 155, // Increased width
                                height: 155, // Increased height
                                fit: BoxFit.contain,
                              ),
                            ), // Image at top left corner
                          ),
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Text(
                              "ChatGPT",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: semibold,
                                  color: Colors.white),
                            ), // Icon on bottom left corner
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ), // Arrow on bottom right corner
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  500), // Adjust the duration as needed
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ChatPage(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(21, 255, 255,
                            255), // Adjust opacity as per your preference
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromARGB(53, 255, 255,
                              255), // Specify the border color here
                          width: 1, // Adjust the border width as needed
                        ),
                        boxShadow: [
                          // BoxShadow(
                          //   color: Color.fromARGB(255, 129, 103, 182)
                          //       .withOpacity(0.9),
                          //   spreadRadius: 60,
                          //   blurRadius: 90,
                          //   offset: Offset(-180, -20),
                          // ),
                        ],
                      ),
                      width: width * 0.6,
                      height: (height * 0.25) + 15,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            right: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  22), // Rounded border with a radius of 22
                              child: Image.asset(
                                img, // Replace with your image URL
                                width: 155, // Increased width
                                height: 155, // Increased height
                                fit: BoxFit.contain,
                              ),
                            ), // Image at top left corner
                          ),
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Text(
                              "ChatGPT",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: semibold,
                                  color: Colors.white),
                            ), // Icon on bottom left corner
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ), // Arrow on bottom right corner
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  500), // Adjust the duration as needed
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ChatPage(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(21, 255, 255,
                            255), // Adjust opacity as per your preference
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromARGB(53, 255, 255,
                              255), // Specify the border color here
                          width: 1, // Adjust the border width as needed
                        ),
                        boxShadow: [
                          // BoxShadow(
                          //   color: Color.fromARGB(255, 129, 103, 182)
                          //       .withOpacity(0.9),
                          //   spreadRadius: 60,
                          //   blurRadius: 90,
                          //   offset: Offset(-180, -20),
                          // ),
                        ],
                      ),
                      width: width * 0.6,
                      height: (height * 0.25) + 15,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            right: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  22), // Rounded border with a radius of 22
                              child: Image.asset(
                                img, // Replace with your image URL
                                width: 155, // Increased width
                                height: 155, // Increased height
                                fit: BoxFit.contain,
                              ),
                            ), // Image at top left corner
                          ),
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Text(
                              "ChatGPT",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: semibold,
                                  color: Colors.white),
                            ), // Icon on bottom left corner
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ), // Arrow on bottom right corner
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  500), // Adjust the duration as needed
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ChatPage(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(21, 255, 255,
                            255), // Adjust opacity as per your preference
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color.fromARGB(53, 255, 255,
                              255), // Specify the border color here
                          width: 1, // Adjust the border width as needed
                        ),
                        boxShadow: [
                          // BoxShadow(
                          //   color: Color.fromARGB(255, 129, 103, 182)
                          //       .withOpacity(0.9),
                          //   spreadRadius: 60,
                          //   blurRadius: 90,
                          //   offset: Offset(-180, -20),
                          // ),
                        ],
                      ),
                      width: width * 0.6,
                      height: (height * 0.25) + 15,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 15,
                            left: 10,
                            right: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  22), // Rounded border with a radius of 22
                              child: Image.asset(
                                img, // Replace with your image URL
                                width: 155, // Increased width
                                height: 155, // Increased height
                                fit: BoxFit.contain,
                              ),
                            ), // Image at top left corner
                          ),
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: Text(
                              "ChatGPT",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: semibold,
                                  color: Colors.white),
                            ), // Icon on bottom left corner
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ), // Arrow on bottom right corner
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    super.key,
    required String username,
    required String userProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 15, 11, 22), // Set background color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        igvector3), // Replace 'igvector3.jpg' with your image asset path
                    fit: BoxFit.cover, // Adjust this property as needed
                  ),
                ),
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 6,
                        sigmaY: 6,
                      ), // Adjust blur intensity as needed
                      child: Container(),
                    ),
                    Center(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoyGf1bPcpDfimN7bdXzD_t04-F819n1XF73fReG4yPQ&s', // Replace with your avatar image URL
                            ),
                          ),
                          SizedBox(
                              width: 16), // Add spacing between avatar and text
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: semibold,
                              fontSize: 28,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 8,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Add spacing between header and list items
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Update the UI based on drawer item selected
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Update the UI based on drawer item selected
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileAddPage(),
                    ),
                  );
                  // Update the UI based on drawer item selected
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
