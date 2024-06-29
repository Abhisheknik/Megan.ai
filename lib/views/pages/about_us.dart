import 'package:ai_app/const/image_url.dart';
import 'package:ai_app/const/typography.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Abhishek Nikam',
      role: 'UI/System Desgin',
      bio:
          'Meet Abhishek Nikam, the mastermind at Megan.ai. He creates stunning UIs, engineers the system, and conjures up cloud solutions with Firebase magic!',
      imageUrl: igabhi,
    ),
    TeamMember(
      name: 'Bhagwatilal Joshi',
      role: 'Core Developer',
      bio:
          'Meet Bhagwatilal Joshi, the genius behind Megan.ai s AI tools. As the mastermind of Megan.ai s promotional website, his the wizard making AI magic happen!',
      imageUrl: igjoshi,
    ),
    TeamMember(
      name: 'Praful Vishwakarma',
      role: 'Core Developer',
      bio:
          'Meet Praful Vishwakarma, the genius behind our eCommerce magic. He ensures your orders arrive quickly, secures payments, and keeps hackers at bay.',
      imageUrl: igharsh,
    ),
    TeamMember(
      name: 'Harshal Bhoye',
      role: 'UI/UX Desginer',
      bio:
          'Meet Harshal Bhoye, the artistic mind behind our app s UI. He crafts a vintage look with a classy black and white theme, blending elegance and simplicity to create a timeless user experience',
      imageUrl: igpar,
    ),
    // Add more team members as needed
  ];

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
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Our mission is to leverage AI to create innovative solutions that improve everyday life. We aim to push the boundaries of what technology can achieve.',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: regular,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: teamMembers.map((member) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      color: Colors.grey[900],
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(member.imageUrl),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    member.role,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    member.bio,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: regular,
                                      color: Colors.white70,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Text(
                'Technology Stack',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'We use the latest technologies to ensure our app is fast, secure, and reliable. Our technology stack includes Flutter, Dart, Firebase, and Gen Ai Models, Razorpay.',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: regular,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'About the App',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Our app is designed to provide users with cutting-edge AI tools that enhance productivity and creativity. With features like video generation, image upscaling, and more, we aim to deliver an unparalleled user experience.',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: regular,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String bio;
  final String imageUrl;

  TeamMember({
    required this.name,
    required this.role,
    required this.bio,
    required this.imageUrl,
  });
}
