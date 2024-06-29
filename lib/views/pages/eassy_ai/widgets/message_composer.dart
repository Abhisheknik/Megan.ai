import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({
    required this.onSubmitted,
    required this.finalQuestion,
    required this.awaitingResponse,
    required this.generatedText,
    Key? key,
  }) : super(key: key);

  final void Function(String) onSubmitted;
  final String finalQuestion;
  final bool awaitingResponse;
  final String generatedText;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Align(
                child: !widget.awaitingResponse
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Re-Generate Button
                                Container(
                                  width: 120,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.onSubmitted(widget.finalQuestion);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const Text(
                                      'Re-Generate',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                                // Copy Button
                                Container(
                                  width: 120,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _copyToClipboard(widget.generatedText);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const Text(
                                      'Copy',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(11, 240, 255, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Fetching response...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }
}
