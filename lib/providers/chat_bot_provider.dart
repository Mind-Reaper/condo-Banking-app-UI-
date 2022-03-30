import 'package:flutter/material.dart';

class ChatBotProvider with ChangeNotifier {


  bool botIsTyping = false;
  ScrollController scrollController = ScrollController();


  List<Map<String, dynamic>> chatList = [
    {'sender': 1, 'text': 'Can you help me?', 'timeStamp': DateTime.now()},
    //sender 0 is bot, sender 1 is user, sender 3 is note chat, sender 4 is 'typing'
    {
      'sender': 3,
      'text': 'entered the chat',
      'timeStamp': DateTime.now().add(Duration(minutes: 1))
    },
    {
      'sender': 0,
      'text': 'Hello ?',
      'timeStamp': DateTime.now().add(Duration(minutes: 1))
    },
    {
      'sender': 0,
      'text': 'My name is Colin',
      'timeStamp': DateTime.now().add(Duration(minutes: 1))
    },
    {
      'sender': 0,
      'text': 'Your virtual support and ready to help you',
      'timeStamp': DateTime.now().add(Duration(minutes: 1))
    },



  ];

  addToChat({required String text, required int sender}) {
    chatList.add({'sender': sender, 'text': text, 'timeStamp': DateTime.now()});
    notifyListeners();
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
    notifyListeners();
    if(!botIsTyping) {
      botResponse();
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      notifyListeners();
    }

  }

  botResponse() async {
    botIsTyping = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 5));
    addToChat(text: 'Hello!', sender: 0);
    botIsTyping = false;
    notifyListeners();
    await Future.delayed(Duration(seconds: 3));
    botIsTyping = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 5));
    addToChat(text: 'How can I help you? 😎', sender: 0);
    botIsTyping = false;
    notifyListeners();

  }

}
