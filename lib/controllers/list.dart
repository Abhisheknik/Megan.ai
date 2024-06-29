import 'package:ai_app/models/ai_model.dart';
import 'package:ai_app/packages/package.dart';
import 'package:ai_app/views/pages/chatgemini/home_page.dart';
import 'package:ai_app/views/pages/eassy_ai/application_home_page.dart';
import 'package:ai_app/views/pages/eassy_ai/assignment_home_page.dart';
import 'package:ai_app/views/pages/eassy_ai/essay_home_page.dart';
import 'package:ai_app/views/pages/eassy_ai/latter_home_page.dart';
import 'package:ai_app/views/pages/remover/views/remove_bg_screen.dart';
import 'package:ai_app/views/pages/text_finder/text_finder.dart';
import 'package:ai_app/views/pages/text_to_img/texttoimg.dart';

List<AiDetailsModel> aiList = [
  AiDetailsModel(
    img: img6,
    title: "Ai Chat",
    icon: Icons.person,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => Chatgemini(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
  AiDetailsModel(
    img: img7,
    title: "Text To Img",
    icon: Icons.brush,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => TextToImage(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
  AiDetailsModel(
    img: img2,
    title: "Text Finder",
    icon: Icons.find_in_page,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => TextFinder(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
  AiDetailsModel(
    img: img3,
    title: "Back Remover",
    icon: Icons.remove_circle,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => RemoveBackgroundScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
  AiDetailsModel(
    img: img4,
    title: "Essay Ai",
    icon: Icons.pages,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => EssayMyHomePage(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
  AiDetailsModel(
    img: img5,
    title: "Letter Ai",
    icon: Icons.email,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => LatterMyHomePage(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
  AiDetailsModel(
    img: img1,
    title: "Application Ai",
    icon: Icons.settings_applications,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => ApplicationMyHomePage(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
  AiDetailsModel(
    img: img2,
    title: "Assignment Ai",
    icon: Icons.edit,
    onTap: (BuildContext context) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 300), // Adjust transition duration
          pageBuilder: (_, __, ___) => AssignmentMyHomePage(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut, // Use a smooth animation curve
              )),
              child: child,
            );
          },
        ),
      );
    },
  ),
];
