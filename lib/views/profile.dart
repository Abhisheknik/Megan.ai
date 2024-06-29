import 'dart:io';
import 'package:ai_app/Packages/package.dart';
import 'package:ai_app/packages/package.dart';
import 'package:ai_app/views/pages/about_us.dart';
import 'package:ai_app/views/pages/ecom/orderpage.dart';
import 'package:ai_app/views/pages/upcoming.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: Color.fromARGB(240, 0, 0, 0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Form(
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
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: image != null
                              ? FileImage(image!)
                              : (imageUrl != null
                                      ? CachedNetworkImageProvider(imageUrl!)
                                      : AssetImage(igmars))
                                  as ImageProvider<Object>,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -5,
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUsPage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.white), // Add your icon here
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'About Us ',
                              textAlign:
                                  TextAlign.left, // Align text to the left
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily:
                                    'Roboto', // Replace with your font if necessary
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderPage()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.shopping_cart_checkout,
                                color: Colors.white), // Add your icon here
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'My Orders',
                              textAlign:
                                  TextAlign.left, // Align text to the left
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily:
                                    'Roboto', // Replace with your font if necessary
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Add some spacing between the rows
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpcomingFeaturePage(),
                            ),
                          ); // Navigate to another page
                        },
                        child: Row(
                          children: [
                            Icon(Icons.star_outline,
                                color: Colors.white), // Add your icon here
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'Upcoming Features ',
                              textAlign:
                                  TextAlign.left, // Align text to the left
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily:
                                    'Roboto', // Replace with your font if necessary
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), // Add some spacing between the rows
                      GestureDetector(
                        onTap: () async {
                          final Uri _emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'contact@meganai.com',
                            queryParameters: {
                              'subject': 'Inquiry'
                            }, // You can customize the subject here
                          );
                          if (await canLaunch(_emailLaunchUri.toString())) {
                            await launch(_emailLaunchUri.toString());
                          } else {
                            throw 'Could not launch email';
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.contact_emergency,
                                color: Colors.white), // Add your icon here
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'Contact Us ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily:
                                    'Roboto', // Replace with your font if necessary
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20), // Add some spacing between the rows
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, '/another_page'); // Navigate to another page
                        },
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.white), // Add your icon here
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'Version 1.0.0',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily:
                                    'Roboto Mono', // Replace with your font if necessary
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), // Add some spacing between the rows
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          ); // Navigate to another page
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout,
                                color: Colors.white), // Add your icon here
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'Logout',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily:
                                    'Roboto', // Replace with your font if necessary
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
