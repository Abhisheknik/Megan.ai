import 'package:ai_app/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_app/views/pages/remover/components/snackbar.dart'; // Import the snackbar component
import '../controllers/remove_bg_controller.dart';
import '../components/choose_image.dart';
import '../components/primary_button.dart';

class RemoveBackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final RemoveBgController controller = Get.put(RemoveBgController());

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(22, 21, 21, 21),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Center(
          child: Text(
            'Remove Background',
            style: TextStyle(
              fontFamily: semibold,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: Center(
        child: GetBuilder<RemoveBgController>(
          builder: (localController) {
            // Renamed variable to avoid conflict
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (localController.imageFile != null)
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Image.memory(
                                localController.imageFile!,
                              ),
                            ),
                            const SizedBox(height: 40),
                            localController.isRemovingBackground.value
                                ? CircularProgressIndicator()
                                : ReusablePrimaryButton(
                                    childText: "Remove Background",
                                    textColor: Color.fromARGB(255, 0, 0, 0),
                                    buttonColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    onPressed: () async {
                                      if (localController.imageFile == null) {
                                        showSnackBar("Error",
                                            "Please select an image", true);
                                      } else {
                                        await localController
                                            .removeBackground();
                                      }
                                    },
                                  ),
                            const SizedBox(height: 20),
                            ReusablePrimaryButton(
                              childText: "Save Image",
                              textColor: Color.fromARGB(255, 0, 0, 0),
                              buttonColor: Color.fromARGB(255, 255, 255, 255),
                              onPressed: () async {
                                if (localController.imageFile != null) {
                                  await localController.saveImage();
                                  // Show success message using AlertDialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Success"),
                                        content:
                                            Text("Image saved successfully"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Handle case when no image is selected
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Please select an image"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            ReusablePrimaryButton(
                              childText: "Add New Image",
                              textColor: const Color.fromARGB(255, 0, 0, 0),
                              buttonColor: Color.fromARGB(255, 255, 255, 255),
                              onPressed: () async {
                                localController.cleanUp();
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 0.2),
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ReusablePrimaryButton(
                              childText: "Select Image",
                              textColor: Color.fromARGB(255, 0, 0, 0),
                              buttonColor: Color.fromARGB(255, 255, 255, 255),
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return bottomSheet(controller, context);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
