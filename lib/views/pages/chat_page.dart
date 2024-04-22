import 'dart:convert';
import 'dart:ui';

import 'package:ai_app/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:ai_app/const/color_platte.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_app/const/image_url.dart';
import 'package:ai_app/models/key_api.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
              'GPT Chat',
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
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 15, 11, 22), // Set background color
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          igvector3), // Replace 'igvector3.jpg' with your image asset path
                      fit: BoxFit.cover, // Adjust this property as needed
                    ),
                  ),
                  child: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 6,
                          sigmaY: 6,
                        ), // Adjust blur intensity as needed
                        child: Container(),
                      ),
                      Center(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoyGf1bPcpDfimN7bdXzD_t04-F819n1XF73fReG4yPQ&s', // Replace with your avatar image URL
                              ),
                            ),
                            SizedBox(
                                width:
                                    16), // Add spacing between avatar and text
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: semibold,
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
                SizedBox(
                    height: 20), // Add spacing between header and list items
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
                    // Load the chat history
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
                    // Update the UI based on drawer item selected
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildChatBody(),
    );
  }

  Widget _buildChatBody() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(igvector3),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.1),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: DashChat(
        currentUser: _currentUser,
        messageOptions: MessageOptions(
          currentUserContainerColor: blackColor,
          containerColor: purpleColor,
          textColor: Colors.black,
        ),
        onSend: _getChatResponse,
        messages: _messages,
      ),
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

  @override
  void initState() {
    super.initState();
    // Load chat history only if _messages list is empty
    if (_messages.isEmpty) {
      _loadChatHistory();
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
