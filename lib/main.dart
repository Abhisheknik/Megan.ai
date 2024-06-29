import 'package:ai_app/Packages/package.dart';
import 'package:ai_app/views/pages/Home.dart';
import 'package:ai_app/views/pages/chatgemini/consts.dart';
import 'package:ai_app/views/pages/ecom/orderpage.dart';
import 'package:ai_app/views/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

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
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(fontFamily: regular, scaffoldBackgroundColor: Colors.black),
      initialRoute: '/', // Initial route
      routes: {
        '/': (context) => Onbroadingppage(),
        '/lib/views/auth_screens/signup_page.dart': (context) =>
            SignUpPage(), // Initial route
        '/lib/views/auth_screens/login_page.dart': (context) =>
            LoginPage(), // Login route
        '/lib/views/ai_tool.dart': (context) => AiTool(),
        '/lib/views/pages/ecom/orderpage.dart': (context) => OrderPage(),
        '/lib/views/profile.dart': (context) => ProfileAddPage(),
        '/lib/views/pages/Home.dart': (context) => EcomPage(), // Home route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
