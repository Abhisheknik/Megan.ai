import 'dart:typed_data';
import 'package:ai_app/views/pages/remover/components/snackbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class RemoveBgController extends GetxController {
  Uint8List? imageFile;
  String? imagePath;
  ScreenshotController controller = ScreenshotController();
  var isLoading = false.obs;
  var isRemovingBackground = false.obs;

  Future<void> removeBackground() async {
    isRemovingBackground.value = true;
    update(); // Notify the UI that the state has changed

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("https://api.remove.bg/v1.0/removebg"));
      request.files
          .add(await http.MultipartFile.fromPath("image_file", imagePath!));
      request.headers.addAll({"X-API-Key": "oCHTDvPXpxts8CdDS7ajDm5v"});
      final response = await request.send();
      if (response.statusCode == 200) {
        http.Response imgRes = await http.Response.fromStream(response);
        imageFile = imgRes.bodyBytes;
        isLoading.value = false;
        isRemovingBackground.value = false;
        update(); // Notify the UI that the state has changed
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      // Handle errors
      isLoading.value = false;
      isRemovingBackground.value = false;
      update(); // Notify the UI that the state has changed
    }
  }

  void pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().getImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        update();
      }
    } catch (e) {
      imageFile = null;
      update();
    }
  }

  void cleanUp() {
    imageFile = null;
    update();
  }

  Future<void> saveImage() async {
    bool isGranted = await Permission.storage.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.storage.request().isGranted;
    }
    if (isGranted && imageFile != null) {
      await ImageGallerySaver.saveImage(imageFile!);
      showSnackBar("Success", "Image saved successfully", false);
      // Add the success message here
    } else {
      showSnackBar("Error", "Image could not be saved", true);
    }
  }
}
