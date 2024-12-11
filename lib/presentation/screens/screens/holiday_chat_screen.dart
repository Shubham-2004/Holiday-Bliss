// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutable
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:holiday_bliss/backend/api_service.dart';
import 'package:holiday_bliss/widgets/bot_chat_text.dart';
import 'package:holiday_bliss/widgets/my_chat_text.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  List messages = [];
  List<File> images = [];
  String prompt =
      "You are a shopping assistant bot. Your primary role is to help users find the best deals, track their inventory, and manage their shopping lists. Respond to queries about product availability, discounts, and suggest items to add to their list based on their preferences. Maintain a polite and friendly tone, ensuring clear and efficient assistance.";

  Future<void> getAnswers(String userQuery) async {
    String? response = await ApiService.generateContent(prompt + userQuery);

    if (response != null) {
      try {
        // Parse the response
        final Map<String, dynamic> jsonResponse = json.decode(response);
        final List<dynamic>? parts = jsonResponse['candidates']?[0]['content']
                ?['parts']?[0]?['text']
            ?.split(' ');

        if (parts != null && parts.isNotEmpty) {
          setState(() {
            messages.add(BotChatText(
                text: parts.join(' '))); // Combine parts into a single response
          });
        } else {
          setState(() {
            messages.add(BotChatText(
              text:
                  "I'm sorry, I couldn't process your request. Please try again later.",
            ));
          });
        }
      } catch (e) {
        setState(() {
          messages.add(BotChatText(
            text: "An error occurred while processing the response.",
          ));
        });
      }
    } else {
      setState(() {
        messages.add(BotChatText(
          text:
              "I'm sorry, I couldn't process your request. Please try again later.",
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Shopping Assistant AI',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(15).copyWith(top: 10, bottom: 10),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.teal[100]!,
            Colors.teal[300]!,
            Colors.teal[100]!,
          ],
        )),
        child: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(bottom: 60),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: images.isNotEmpty ? 170 : 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    if (images.isNotEmpty)
                      Container(
                        height: 100,
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(images[index]),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          images.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (pickedFile != null) {
                              setState(() {
                                images.add(File(pickedFile.path));
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.black87,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 20),
                            controller: messageController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Enter your message',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send, color: Colors.black),
                                onPressed: () {
                                  final userMessage = messageController.text;
                                  if (userMessage.isNotEmpty) {
                                    setState(() {
                                      messages.add(MyChatText(
                                        text: userMessage,
                                        images: images,
                                      ));
                                      messageController.clear();
                                      images.clear();
                                    });
                                    getAnswers(userMessage);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
