import 'package:ai_app/views/pages/eassy_ai/chat_page.dart';
import 'package:ai_app/views/pages/eassy_ai/widgets/appbar.dart';
import 'package:flutter/material.dart';

class EssayMyHomePage extends StatefulWidget {
  const EssayMyHomePage({
    super.key,
  });

  @override
  State<EssayMyHomePage> createState() => _EssayMyHomePageState();
}

class _EssayMyHomePageState extends State<EssayMyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String s1 = 'Write an essay on ',
      s2 = ' include ',
      s3 = ' in ',
      s4 = ' language in ',
      s5 = ' words.',
      title = 'Topic :- ';

  final TextEditingController _questionController = TextEditingController();
  String question = '';

  final TextEditingController _tagsController = TextEditingController();
  String tags = '';

  String language = 'English';
  List<String> dropdownItems = ['English', 'Hindi'];

  final TextEditingController _wordsizeController = TextEditingController();
  String wordsize = '';

  String finalQuestion = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          key: _scaffoldKey,
          appBar: CustomAppBar(
            scaffoldKey: _scaffoldKey,
            onProfilePressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          body: Container(
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 18),
                      child: const Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                text: 'Write ',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Essays ',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Color.fromRGBO(82, 82, 82, 1),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\nwith Powered AI',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.23,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: TextField(
                        controller: _questionController,
                        onChanged: (value) {
                          setState(() {
                            question = value;
                          });
                        },
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Write a best match title/prompt',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(112, 108, 108, 39),
                            fontFamily: 'Poppins',
                          ),
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.065,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: TextField(
                        controller: _tagsController,
                        onChanged: (value) {
                          setState(() {
                            tags = value;
                          });
                        },
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add Tags, Keywords (Use, to add)',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(112, 108, 108, 39),
                            fontFamily: 'Poppins',
                          ),
                          contentPadding: EdgeInsets.all(12.0),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Text(
                            '  Choose Language',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            width: 100,
                            height: 36,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: DropdownButton<String>(
                              value: language,
                              onChanged: (newValue) {
                                setState(() {
                                  language = newValue!;
                                });
                              },
                              items: dropdownItems.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                              dropdownColor:
                                  const Color.fromRGBO(35, 35, 35, 1),
                              iconSize: 30,
                              underline: Container(
                                height: 0,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Text(
                            '  Word Count',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          Container(
                            width: 100,
                            height: 36,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: TextField(
                              controller: _wordsizeController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  wordsize = value;
                                });
                              },
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Eg-75',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(112, 108, 108, 39),
                                  fontFamily: 'Poppins',
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 15, top: 3),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Expanded(
                        child: Align(
                            child: SizedBox(
                      width: screenWidth * 0.9,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () {
                            if (_questionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please Add Subject.')),
                              );
                            } else {
                              setState(() {
                                finalQuestion =
                                    "$s1$question$s2$tags$s3$language$s4$wordsize$s5";
                                title = "$title$question";
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatpPage(
                                      finalQuestion: finalQuestion,
                                      question: title),
                                ));
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text('Submit',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ))),
                    ))),
                  ],
                ),
              ),
            ]),
          )),
    );
  }
}
