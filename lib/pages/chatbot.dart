import 'package:auto_animated/auto_animated.dart';
import 'package:condo/providers/chat_bot_provider.dart';
import 'package:condo/widgets/chat_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController textController = TextEditingController();

  double initialPosition = 0.0;
  double endPosition = 0.0;
  double distance = 0.0;

  @override
  Widget build(BuildContext context) {
    var chat = Provider.of<ChatBotProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/support.png'),
                      radius: 24,
                    ),
                    Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff32D74B),
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor, width: 2)),
                    )
                  ],
                ),
              ),
              SizedBox(width: 11),
              Text(
                'Support',
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodyText1!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            Center(
              child: Container(
                height: 44,
                width: 48,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.more_vert_outlined, size: 24),
              ),
            ),
            SizedBox(width: 16)
          ],
        ),

        body: Column(
          children: [
            Expanded(
              child: NotificationListener(
                // onNotification: (ScrollMetricsNotification notif) {
                //
                //   if (notif.metrics.extentAfter - notif.metrics.extentBefore > MediaQuery.of(context).size.h) {
                //     print( notif.metrics.extentAfter- notif.metrics.extentBefore );
                //     FocusScope.of(context).unfocus();
                //   }
                //   return true;
                // },
                child: LiveList.options(
                  options: LiveOptions(
                  showItemDuration: Duration(milliseconds: 100),

                  ),
                  padding: EdgeInsets.only(left: 16, right:  16, top: 16, bottom: 40),
                  controller: chat.scrollController,
                  // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: chat.chatList.length,
                  itemBuilder: (context, index, animation) {
                 Map<String, dynamic> item = chat.chatList[index];

                 if(item['sender'] == 0) {
                   return BotChat(
                     text: item['text'],
                     timestamp: item['timeStamp'],
                     animation: animation,
                     first: index > 0 && index < chat.chatList.length - 1 ?  chat.chatList[index-1]['sender'] != 0 && chat.chatList[index+1]['sender'] == 0 : false,
                     middle: index > 0 && index < chat.chatList.length - 1 ?  chat.chatList[index-1]['sender'] == 0 && chat.chatList[index+1]['sender'] == 0: false,
                     last: index > 0 && index < chat.chatList.length - 1 ?  chat.chatList[index-1]['sender'] == 0 && chat.chatList[index+1]['sender'] != 0 : false,
                   );
                 } else if (item['sender'] == 1){
                   return UserChat(
                     text: item['text'],
                     timestamp: item['timeStamp'],
                     animation: animation,
                     first:  index > 0 && index < chat.chatList.length - 1 ?  chat.chatList[index-1]['sender'] != 1 && chat.chatList[index+1]['sender'] == 1: false,
                     middle: index > 0 && index < chat.chatList.length - 1 ?  chat.chatList[index-1]['sender'] == 1 && chat.chatList[index+1]['sender'] == 1 : false,
                     last: index > 0 && index < chat.chatList.length - 1 ?  chat.chatList[index-1]['sender'] == 1 && chat.chatList[index+1]['sender'] != 1 : false,
                   );
                 } else {
                   return NoteChat(text:item['text']);
                 }
                  },
                ),
              ),
            ),
            Container(
              child: chat.botIsTyping ?  NoteChat(): null,
            ),
            Container(
              height: 76,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                          width: 48,
                          child: Center(
                              child: ImageIcon(AssetImage('assets/images/attachment.png'), size: 24))),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextField(
                            controller: textController,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1!
                                .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                            maxLines: 3,
                            minLines: 1,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type here...',
                              hintStyle: TextStyle(
                                fontSize: 20,
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w600,
                                // color: Theme.of(context).canvasColor
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (textController.text.isNotEmpty) {
                            chat.addToChat(text: textController.text, sender: 1);
                          }
                          textController.clear();
                        },
                        child: Container(
                          height: 44,
                          width: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [Color(0xffFFD60A), Color(0xff32D74B)])),
                          child: Center(
                            child: ImageIcon(
                              AssetImage('assets/images/send.png'),
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
}


