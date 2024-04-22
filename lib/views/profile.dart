import 'dart:io';
import 'package:ai_app/Packages/package.dart';
import 'package:ai_app/const/image_url.dart';
import 'package:ai_app/packages/package.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAddPage extends StatefulWidget {
  const ProfileAddPage({Key? key}) : super(key: key);

  @override
  State<ProfileAddPage> createState() => _ProfileAddPageState();
}

class _ProfileAddPageState extends State<ProfileAddPage> {
  File? _image;
  final picker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? imageUrl;
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Fetch user data including imageUrl when the page is initialized
      _getUserData(currentUser.uid).then((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['name'];
            _emailController.text = data['email'];
            imageUrl =
                data['profile_picture']; // Update imageUrl from Firestore
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<DocumentSnapshot> _getUserData(String uid) async {
    return await _firestore.collection('sign_data').doc(uid).get();
  }

  Future<void> _handleFormSubmission(String newName, String newEmail) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return; // Handle error appropriately
    }

    try {
      // Check if an image is selected
      if (_image == null) {
        // If no image is selected, update user document in Firestore without profile picture URL
        await _firestore.collection('sign_data').doc(currentUser.uid).update({
          'name': newName,
          'email': newEmail,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        return; // Exit the method
      }

      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToStorage(_image!, currentUser.uid);

      // Update imageUrl in state immediately
      setState(() {
        this.imageUrl = imageUrl;
      });

      // Update user document in Firestore with new profile picture URL
      await _firestore.collection('sign_data').doc(currentUser.uid).update({
        'name': newName,
        'email': newEmail,
        'profile_picture': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImageToStorage(File imageFile, String userId) async {
    try {
      // Get the file extension of the image
      String fileExtension = imageFile.path.split('.').last.toLowerCase();

      // Specify the desired format (JPG or PNG)
      String format = fileExtension == 'jpg' ? 'jpg' : 'png';

      // Upload image to Firebase Storage with the specified format
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref(
              'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}.$format')
          .putFile(imageFile);

      // Get download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully. Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> _showImagePicker() async {
    final ImagePicker _picker = ImagePicker();

    final PickedFile? pickedImage =
        await _picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      print('Image selection cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login_page');
      });
      return Container();
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(241, 8, 0, 23),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'semibold', // Assuming 'semibold' is defined somewhere
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(currentUser.uid),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/login_page');
            });
            return SizedBox.shrink();
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            if (data == null) {
              return Text('No user data available.');
            }

            _nameController.text = data['name'];
            _emailController.text = data['email'];

            return ProfileForm(
              imageUrl: imageUrl,
              onImageChanged: (File image) {
                setState(() {
                  _image = image;
                });
              },
              nameController: _nameController,
              emailController: _emailController,
              onSubmit: _handleFormSubmission,
              showImagePicker: _showImagePicker,
              image: _image,
            );
          }
        },
      ),
    );
  }
}

class ProfileForm extends StatelessWidget {
  final String? imageUrl;
  final Function(File) onImageChanged;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final Function(String, String) onSubmit;
  final VoidCallback showImagePicker;
  final File? image;

  const ProfileForm({
    Key? key,
    this.imageUrl,
    required this.onImageChanged,
    required this.nameController,
    required this.emailController,
    required this.onSubmit,
    required this.showImagePicker,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // Wrap the Stack in a container with Alignment.center
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: image != null
                          ? FileImage(image!)
                          : (imageUrl != null
                              ? CachedNetworkImageProvider(imageUrl!)
                              : AssetImage(igvector3)) as ImageProvider<Object>,
                    ),
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.camera_alt),
                        onPressed: showImagePicker,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                style: TextStyle(color: Colors.white, fontFamily: regular),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                style: TextStyle(color: Color.fromARGB(255, 254, 254, 254)),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    onSubmit(nameController.text, emailController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // side: BorderSide(color: Colors.white),
                    elevation: 0, // Remove button elevation
                  ),
                  child: Text(
                    'Save ',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: regular, // or 'Courier' for example
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.white, // Customize the color of the divider
                thickness: 1, // Customize the thickness of the divider
                height: 10, // Customize the height of the divider
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/about_us'); // Navigate to the About Us page
                    },
                    child: Text(
                      'About Us 👥',
                      textAlign: TextAlign.left, // Align text to the left
                      style: TextStyle(
                        fontSize: 16, color: Colors.white,
                        fontFamily: regular, // or 'Courier' for example
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/another_page'); // Navigate to another page
                    },
                    child: Text(
                      'Upcoming Features 🌟',
                      textAlign: TextAlign.left, // Align text to the left
                      style: TextStyle(
                        fontSize: 16, color: Colors.white,
                        fontFamily: regular, // or 'Courier' for example
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/another_page'); // Navigate to another page
                    },
                    child: Text(
                      'Help 🆘',
                      textAlign: TextAlign.left, // Align text to the left
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: regular, // or 'Courier' for example
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(
                      //     context, '/another_page'); // Navigate to another page
                    },
                    child: Text(
                      'Version 0.0.1',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Roboto Mono', // or 'Courier' for example
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      ); // Navigate to another page
                    },
                    child: Text(
                      'Logout',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: regular, // or 'Courier' for example
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
