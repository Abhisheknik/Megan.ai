import 'package:ai_app/const/chat_api.dart';
import 'package:ai_app/models/chat_message.dart';
import 'package:ai_app/views/pages/eassy_ai/widgets/appbar.dart';
import 'package:ai_app/views/pages/eassy_ai/widgets/message_bubble.dart';
import 'package:ai_app/views/pages/eassy_ai/widgets/message_composer.dart';
import 'package:flutter/material.dart';

class ChatpPage extends StatefulWidget {
  const ChatpPage({
    required this.finalQuestion,
    required this.question,
    Key? key,
  }) : super(key: key);

  final String finalQuestion;
  final String question;

  @override
  State<ChatpPage> createState() => _ChatpPageState();
}

class _ChatpPageState extends State<ChatpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _onSubmitted(widget.finalQuestion);
  }

  final _messages = <ChatMessage>[];
  var _awaitingResponse = false;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String subject = widget.question;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          onProfilePressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        drawer: const Drawer(),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth * 1,
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        subject,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      content: _messages[index].content,
                      isUserMessage: _messages[index].isUserMessage,
                    );
                  },
                ),
              ),
              MessageComposer(
                onSubmitted: _onSubmitted,
                finalQuestion: widget.finalQuestion,
                awaitingResponse: _awaitingResponse,
                generatedText: _messages.isNotEmpty
                    ? _messages.last.content
                    : "", // Pass the last message as generated text
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmitted(String message) async {
    setState(() {
      _messages.add(ChatMessage(message, true));
      _awaitingResponse = true;
    });
    try {
      final response = await ChatApi().completeChat(_messages);
      setState(() {
        _messages.add(ChatMessage(response, false));
        _awaitingResponse = false;
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
      setState(() {
        _awaitingResponse = false;
      });
    }
  }
}
