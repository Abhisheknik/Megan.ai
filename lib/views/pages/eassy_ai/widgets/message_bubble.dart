import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    Key? key,
  }) : super(key: key);
  final String content;
  final bool isUserMessage;

  @override
  Widget build(BuildContext context) {
    if (!isUserMessage) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(35, 35, 35, 5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: content,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
