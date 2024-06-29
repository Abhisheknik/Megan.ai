import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:ai_app/views/ai_tool.dart';
import 'package:ai_app/views/pages/chatgemini/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:ai_app/const/typography.dart';
import 'package:ai_app/const/color_platte.dart';
import 'package:ai_app/const/image_url.dart';
import 'package:ai_app/models/key_api.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {Key? key, required String question, required String finalQuestion})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late String userProfileImage = "";

  late AnimationController _animationController;
  final ValueNotifier<bool> _isListening = ValueNotifier<bool>(false);

  final OpenAI _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Prafful', lastName: 'Vishwakarma');
  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Abhishek', lastName: 'Ai');
  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUser = <ChatUser>[];
  bool _isLoading = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _text = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _isListening.addListener(_toggleListeningAnimation);
    _initializeSpeech();
    _listenToUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _isListening.removeListener(_toggleListeningAnimation);
    _isListening.dispose();
    super.dispose();
  }

  void _toggleListeningAnimation() {
    if (_isListening.value) {
      _animationController.repeat();
    } else {
      _animationController.reset();
    }
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Container(
            margin: EdgeInsets.only(right: 40),
            child: Text(
              'Ai Chat',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        centerTitle: true,
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
                color: Colors.white,
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
          color: Color.fromARGB(255, 15, 11, 22),
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
                    _loadChatHistory();
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
                      _messages.clear();
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
      body: _buildChatBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 5),
        child: FloatingActionButton(
          onPressed: _listen,
          tooltip: 'Listen',
          mini: true,
          backgroundColor: _isListening.value
              ? Colors.red
              : Colors.black, // Change color based on listening state
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Icon(
                Icons.mic,
                color: Colors.grey,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChatBody() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: DashChat(
              currentUser: _currentUser,
              messageOptions: MessageOptions(
                currentUserContainerColor: blackColor,
                containerColor: purpleColor,
                textColor: Colors.black,
              ),
              onSend: _getChatResponse,
              messages: _messages,
              inputOptions: InputOptions(
                inputTextStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0)), // Text color
                inputToolbarMargin:
                    EdgeInsets.only(right: 50), // Adjust margin as needed
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUser.add(_gptChatUser);
    });

    final List<Map<String, dynamic>> _messageHistory =
        _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return {'role': 'user', 'content': m.text};
      } else {
        return {'role': 'assistant', 'content': m.text};
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: _messageHistory,
      maxToken: 200,
    );

    final response = await _openAI.onChatCompletion(request: request);

    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: element.message!.content,
            ),
          );
        });
      }
    }

    setState(() {
      _typingUser.remove(_gptChatUser);
    });

    // Save the updated chat history locally after receiving AI response
    await _saveChatHistory();
  }

  void _initializeSpeech() {
    _speech.initialize(
      onError: (error) => print('Error: $error'),
      onStatus: (status) => print('Status: $status'),
    );
  }

  Future<void> _listen() async {
    if (!_speech.isAvailable) {
      print('Speech recognition is not available');
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords ?? ''; // Ensure _text is not null
          });
        },
        onSoundLevelChange: (double level) {
          // You can use sound level change to provide visual feedback
          // For example, you can change the size or color of the microphone button
        },
      );
    } catch (e) {
      print('Error starting speech recognition: $e');
      return;
    }

    _isListening.value =
        true; // Set the value notifier to true when listening starts

    // Wait for speech recognition to complete
    await Future.delayed(
        const Duration(seconds: 5)); // Adjust pause duration as needed

    _isListening.value =
        false; // Set the value notifier to false when listening stops

    // Send the recognized text as a single message
    _sendMessage(_text);
  }

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      final message = ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now(),
        text: text,
      );
      _getChatResponse(message);
    }
  }

  void _loadChatHistory() async {
    setState(() {
      _isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? chatHistory = prefs.getStringList('chatHistory');
    if (chatHistory != null) {
      setState(() {
        _messages
            .clear(); // Clear the existing messages before loading new ones
      });
      for (final String message in chatHistory) {
        final Map<String, dynamic> parsedMessage = json.decode(message);
        final String role = parsedMessage['role'];
        final String content = parsedMessage['content'];
        final ChatMessage chatMessage = ChatMessage(
          user: role == 'user' ? _currentUser : _gptChatUser,
          createdAt: DateTime.now(),
          text: content,
        );
        setState(() {
          _messages.add(chatMessage);
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveChatHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> chatHistory = _messages.map((message) {
      final String role = message.user == _currentUser ? 'user' : 'assistant';
      final Map<String, dynamic> serializedMessage = {
        'role': role,
        'content': message.text,
      };
      return json.encode(serializedMessage);
    }).toList();
    await prefs.setStringList('chatHistory', chatHistory);
  }
}
