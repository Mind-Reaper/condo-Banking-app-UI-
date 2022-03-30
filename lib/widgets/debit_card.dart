import 'package:flutter/material.dart';

class DebitCard extends StatefulWidget {
  final String name;
  final String number;
  final String date;
  final String cash;
  final String issuer;
  final bool bright;
  final Color color1;
  final Color color2;
  final bool shrink;
  final VoidCallback? onTap;

  const DebitCard(
      {Key? key,
      this.name: 'Main card',
      this.number: '5167 1280 3300 1299',
      this.date: '05 / 25',
      this.cash: '£ 7,907.10',
      this.issuer: 'mastercard',
      this.color1: const Color(0xff32D74B),
      this.color2: const Color(0xffFFD60A),
      this.bright: false,
      this.onTap,
      this.shrink: false})
      : super(key: key);

  @override
  State<DebitCard> createState() => _DebitCardState();
}

class _DebitCardState extends State<DebitCard> with SingleTickerProviderStateMixin {
  // bool showPicker = false;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _controller,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: widget.shrink ? 90 : MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: RadialGradient(focal: Alignment.center, radius: 1.5, colors: [
                  widget.color1,
                  widget.color2,
                ]),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: AssetImage('assets/images/noise.png'), fit: BoxFit.cover),
                    gradient: SweepGradient(transform: GradientRotation(2.89), colors: [
                      widget.color1.withOpacity(0.5),
                      widget.color2.withOpacity(0.5),
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          widget.name,
                          style: TextStyle(
                              color: widget.bright ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                          maxLines: 1,
                        )),
                        if (!widget.shrink)
                          Image(
                            image: AssetImage('assets/images/pay.png'),
                            height: 24,
                          ),
                        if (widget.shrink)
                          Text(
                            widget.cash,
                            style: TextStyle(
                                color: widget.bright ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                            maxLines: 1,
                          )
                      ],
                    ),
                    widget.shrink
                        ? Spacer()
                        : SizedBox(
                            height: 10,
                          ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          widget.number,
                          style: TextStyle(
                              color: widget.bright ? Colors.white : Colors.black, fontSize: 16),
                          maxLines: 1,
                        )),
                        if (!widget.shrink)
                          Image(
                            image: AssetImage('assets/images/touch.png'),
                            height: 20,
                          ),
                        if (widget.shrink)
                          Image(
                            image: AssetImage('assets/images/${widget.issuer}.png'),
                            height: 20,
                          )
                      ],
                    ),
                    if (!widget.shrink)
                      SizedBox(
                        height: 8,
                      ),
                    if (!widget.shrink)
                      Text(
                        widget.date,
                        style: TextStyle(
                            color: widget.bright ? Colors.white : Colors.black, fontSize: 16),
                        maxLines: 1,
                      ),
                    if (!widget.shrink) Spacer(),
                    if (!widget.shrink)
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            widget.cash,
                            style: TextStyle(
                                color: widget.bright ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 32),
                            maxLines: 1,
                          )),
                          Image(
                            image: AssetImage('assets/images/${widget.issuer}.png'),
                            height: 24,
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
