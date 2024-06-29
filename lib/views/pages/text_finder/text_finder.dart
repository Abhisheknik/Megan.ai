import 'package:ai_app/packages/package.dart';
import 'package:ai_app/views/pages/text_finder/text_detector.dart';
import 'package:camera/camera.dart';

class TextFinder extends StatefulWidget {
  const TextFinder({Key? key}) : super(key: key);

  @override
  State<TextFinder> createState() => _TextFinder();
}

class _TextFinder extends State<TextFinder> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(240, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Find Text',
          style: TextStyle(color: Colors.white, fontFamily: semibold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.white), // Set back button color to white
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Set text color to white
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                            width: 1.0,
                            color: Colors.white), // Set border color to white
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.green, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Enter the text',
                      hintStyle: TextStyle(
                          color: Colors.white), // Set hint text color to white
                      prefixIcon: Icon(Icons.search, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        text = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        elevation: 1),
                    onPressed: text.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TextRecognizerView(text: text)));
                          },
                    child: const Text('Find'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
