import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ai_app/packages/package.dart';
import 'package:ai_app/views/pages/chat_page.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class Chatgemini extends StatefulWidget {
  const Chatgemini({super.key});

  @override
  State<Chatgemini> createState() => _ChatgeminiState();
}

class _ChatgeminiState extends State<Chatgemini> {
  final Gemini gemini = Gemini.instance;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _speechText = '';
  late String userProfileImage = "";

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Megan",
    profileImage:
        "https://ebsedu.org/wp-content/uploads/elementor/thumbs/AI-Artificial-Intelligence-What-it-is-and-why-it-matters-qb1o8gpaeu2d4z5h27m45d99w1tmlkjwinh4wq1izi.jpg",
  );
  @override
  void initState() {
    super.initState();
    _listenToUserData();
  }

  void _listenToUserData() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          FirebaseFirestore.instance
              .collection('sign_data')
              .doc(user.uid)
              .snapshots()
              .listen((DocumentSnapshot snapshot) {
            if (snapshot.exists) {
              setState(() {
                userProfileImage = snapshot.get('profile_picture') ?? "";
              });
            }
          });
        }
      });
    });
  }

  void updateUserData(String newProfilePicture) {
    setState(() {
      userProfileImage = newProfilePicture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ai Chat",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => Container(
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff171717),
              border: Border.all(
                color: Color.fromARGB(48, 255, 255, 255),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white, // Change icon color here
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onSelected: (String result) {
              if (result == 'Gemini') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chatgemini()),
                );
              } else if (result == 'ChatGPT') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            question: '',
                            finalQuestion: '',
                          )),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Gemini',
                child: Text('Switch to Gemini'),
              ),
              const PopupMenuItem<String>(
                value: 'ChatGPT',
                child: Text('Switch to ChatGPT'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 0, 0, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          img8), // Replace with your image asset path
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 3,
                          sigmaY: 3,
                        ),
                        child: Container(),
                      ),
                      Center(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: userProfileImage.isNotEmpty
                                  ? NetworkImage(userProfileImage)
                                  : AssetImage(igvector14)
                                      as ImageProvider<Object>,
                            ),
                            SizedBox(width: 16),
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'semibold',
                                fontSize: 28,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 8,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    'View History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // _loadChatHistory();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: Text(
                    'New Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      messages.clear();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AiTool(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(
            Icons.image,
          ),
        ),
        IconButton(
          onPressed: _listen,
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
        )
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(
            () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? file = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _listen() async {
    if (!_isListening) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Microphone permission is required")),
        );
        return;
      }

      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == 'listening'),
        onError: (val) {
          print('onError: $val');
          setState(() => _isListening = false);
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _speechText = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _sendMessage(
                ChatMessage(
                  user: currentUser,
                  createdAt: DateTime.now(),
                  text: _speechText,
                ),
              );
              _speechText = '';
              _isListening = false;
              _speech.stop();
            }
          }),
        );
      } else {
        setState(() => _isListening = false);
        print('The user has denied the use of speech recognition.');
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
