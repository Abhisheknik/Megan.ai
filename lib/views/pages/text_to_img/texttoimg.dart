import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ai_app/views/pages/text_to_img/art_screen.dart';
import 'home_provider.dart';

class TextToImage extends ConsumerWidget {
  TextToImage({Key? key}) : super(key: key);

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fWatch = ref.watch(homeProvider);
    final fRead = ref.read(homeProvider);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Megan AI',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArtScreen()),
                    );
                  },
                  icon: Text(
                    'My arts',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            floating: true,
            pinned: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  fWatch.isLoading == true
                      ? Container(
                          alignment: Alignment.center,
                          height: 320,
                          width: 320,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Image.memory(fWatch.imageData!),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: 320,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 0, 0),
                            border: Border.all(color: Colors.white, width: 0.2),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 100,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No Image has been generated yet.',
                                style: GoogleFonts.openSans(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 40),
                  Container(
                    height: 50,
                    width: width * 0.7,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      border: Border.all(color: Colors.white, width: 0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextField(
                      controller: textController,
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your prompt here...',
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          fRead.textToImage(textController.text, context);
                          fRead.searchingChange(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 238, 236, 242),
                                Color.fromARGB(255, 238, 237, 240),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: fWatch.isSearching == false
                              ? Text(
                                  'Generate',
                                  style: GoogleFonts.openSans(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (fWatch.imageData != null) {
                            // Save the generated image to device gallery
                            final result = await ImageGallerySaver.saveImage(
                              Uint8List.fromList(fWatch.imageData!),
                              quality: 100, // adjust image quality if needed
                            );

                            if (result['isSuccess']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Image saved successfully'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to save image'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.black],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          fRead.loadingChange(false);
                          textController.clear();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 243, 243, 243)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Clear',
                            style: GoogleFonts.openSans(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
