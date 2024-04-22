import 'package:ai_app/Packages/package.dart';
import 'package:ai_app/views/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

void main() async {
  // ServicesLocator().init();

  WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();

  await Firebase.initializeApp(
    name: "aiapplogin",
    options: FirebaseOptions(
        apiKey: "AIzaSyDVvNfhU7UJUHRFan54seq9_ZUjlls0UXI",
        appId: "1:778108789672:web:afbedc272a62703e44f39d",
        messagingSenderId: "778108789672",
        projectId: "aiapplogin-b762b",
        databaseURL: "https://aiapplogin-b762b-default-rtdb.firebaseio.com",
        storageBucket: "gs://aiapplogin-b762b.appspot.com"),
  );

  runApp(ProviderScope(child: Screen()));
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/login_page": (context) => LoginPage(),
        "/lib/views/ai_tool": (context) => AiTool(),
      },

      theme:
          ThemeData(fontFamily: regular, scaffoldBackgroundColor: blackColor),
      // home: ChatPage(),
      // home: SignUpPage(),
      // home: TextToImage(),
      // home: Onbroadingppage(),
      home: AiTool(),
      // home: ProfileAddPage(),
      // home: TextFinder(),
      // home: HomePage(),
      // home: ImageToVideoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
