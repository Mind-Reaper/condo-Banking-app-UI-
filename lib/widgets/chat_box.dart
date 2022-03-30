import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class BotChat extends StatelessWidget {
  final String text;
  final DateTime? timestamp;
  final bool first;
  final bool middle;
  final bool last;
  final Animation<double>? animation;

  const BotChat(
      {Key? key,
      this.text: 'Hello',
      this.timestamp,
      this.animation,
      this.first: false,
      this.middle: false,
      this.last: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(animation!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!last && !middle)  SizedBox(height: 8),
          if(!middle && !last)  Text(
              Jiffy(timestamp ?? DateTime.now()).format("h:mm aa").toUpperCase(),
              style: TextStyle(),
            ),
            SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 6,
                  child: last && middle  ? null :   Image(
                    image: AssetImage('assets/images/left_angle.png'),
                  ),
                ),
                IntrinsicWidth(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: 44,
                        minWidth: 70,
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                        color: Color(0xff5E5CE6),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(first
                                ? 0
                                : middle
                                ? 0
                                : last
                                ? 12
                                : 12),
                            bottomRight: Radius.circular(12))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                    )),
                  ),
                ),
              ],
            ),
            if(!first && !middle)  SizedBox(height: 8)
          ],
        ));
  }
}

class UserChat extends StatelessWidget {
  final String text;
  final DateTime? timestamp;
  final bool first;
  final bool middle;
  final bool last;
  final Animation<double>? animation;

  const UserChat(
      {Key? key,
      this.text: 'Hello',
      this.timestamp,
      this.animation,
      this.first: false,
      this.middle: false,
      this.last: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(animation!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if(!last && !middle ) SizedBox(height: 8),
          if(!middle && !last )  Text(
              Jiffy(timestamp ?? DateTime.now()).format("h:mm aa").toUpperCase(),
              style: TextStyle(),
            ),
            SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IntrinsicWidth(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: 44,
                        minWidth: 70,
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(first
                                ? 0
                                : middle
                                    ? 0
                                    : last
                                        ? 12
                                        : 12))),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(text,
                          style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    )),
                  ),
                ),
                Container(
                  height: 8,
                  width: 6,
                  child: last && middle ?  null :
                       Image(
                         color: Theme.of(context).cardColor,
                          image: AssetImage('assets/images/right_angle.png'),
                        )
                      ,
                ),
              ],
            ),
            if(!first && !middle)  SizedBox(height: 8)
          ],
        ));
  }
}

class NoteChat extends StatelessWidget {
  final String? text;
  final String botName;

  const NoteChat({Key? key, this.text, this.botName: 'Colin'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8, horizontal: text == null ? 16: 0),
      child: Row(
        children: [
          Text(
            '$botName ',
            style: Theme.of(context)
                .primaryTextTheme
                .bodyText1!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.6),
          ),
          AnimatedTextKit(
            repeatForever: text == null,
            animatedTexts: [
              TyperAnimatedText(text ?? 'writes a message...',
                  textStyle: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                  speed: Duration(milliseconds: 20))
            ],
          ),
        ],
      ),
    );
  }
}
