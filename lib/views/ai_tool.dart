import 'dart:math';
import 'dart:ui';
import 'package:ai_app/const/image_url.dart';
import 'package:ai_app/controllers/list.dart';
import 'package:ai_app/const/typography.dart';
import 'package:ai_app/models/ai_model.dart';
import 'package:ai_app/views/pages/Home.dart';
import 'package:ai_app/views/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AiTool extends StatefulWidget {
  const AiTool({Key? key}) : super(key: key);

  @override
  State<AiTool> createState() => _AiToolState();
}

class _AiToolState extends State<AiTool> {
  late String username = "Buddy";
  late String userProfileImage = "";
  late String randomMessage = "";

  // List of potential messages
  final List<String> messages = [
    'How may I help you today?',
    'What can I do for you?',
    'Need assistance with something?',
    'How can I assist you?',
    'What do you need help with today?'
  ];

  @override
  void initState() {
    super.initState();
    _listenToUserData();
    _selectRandomMessage();
  }

  void _listenToUserData() {
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
  }

  void _selectRandomMessage() {
    final random = Random();
    randomMessage = messages[random.nextInt(messages.length)];
  }

  void updateUserData(String newName, String newProfilePicture) {
    setState(() {
      username = newName;
      userProfileImage = newProfilePicture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(3, 0), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: Container(
                color: Color.fromARGB(80, 9, 9, 9).withOpacity(0.1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: GNav(
                  // Make the background transparent
                  color: Colors.white,
                  activeColor: Colors.white,
                  gap: 4,
                  padding: EdgeInsets.all(10),
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: "Home",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AiTool()),
                        );
                      },
                    ),
                    GButton(
                      icon: Icons.shop,
                      text: "Shop",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EcomPage()),
                        );
                      },
                    ),
                    GButton(
                      icon: Icons.person,
                      text: "Profile",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileAddPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0, // Remove the shadow
          automaticallyImplyLeading: false, // Remove the back button
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Hey👋 $username",
              textAlign: TextAlign.left, // Aligns text to the left
              style: TextStyle(
                fontFamily: regular,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 1.5,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          centerTitle: false, // Not needed, but included for clarity
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: CircleAvatar(
                  backgroundImage: userProfileImage.isNotEmpty
                      ? NetworkImage(userProfileImage)
                      : AssetImage(igmars) as ImageProvider<Object>,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    randomMessage,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: semibold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: aiList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (context, index) => AiTileWidget(
                    data: aiList[index],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AiTileWidget extends StatelessWidget {
  AiTileWidget({super.key, this.data});

  AiDetailsModel? data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        data!.onTap!(context);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(29),
          color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(data!.img!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data!.title!,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: regular,
                      fontWeight: FontWeight.w900,
                    )),
                Icon(
                  data!.icon, // Display the icon here
                  color: Colors.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
