import 'package:condo/resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/finance_options.dart';
import '../widgets/slider_gradient.dart';

class FinanceOptions extends StatefulWidget {
  final PageController? controller;
  final Color color1;
  final Color color2;
  final String currency;

  const FinanceOptions({Key? key, this.controller, this.color2 = const Color(0xffFFD60A), this.color1 = const  Color(0xff32D74B), this.currency = '€'}) : super(key: key);

  @override
  State<FinanceOptions> createState() => _FinanceOptionsState();
}

class _FinanceOptionsState extends State<FinanceOptions> {
  PageController controller = PageController();
  double sliderValue = 1700;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller!.addListener(() {
      if (widget.controller!.page! <= 1.01) {
        controller.jumpTo(
          MediaQuery.of(context).size.width * widget.controller!.page!,
        );
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          pageSnapping: false,
          children: [
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 107 / 80,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount: financeOptions.length,
                itemBuilder: (context, index) {
                  String item = financeOptions[index];
                  return Option(
                    title: item,
                    icon: item,
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                            child: Container(
                              padding: EdgeInsets.only(top: 12),
                              height: 44,
                              width: 225,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      children: [
                                        GradientText(
                                          '${widget.currency} ${NumberFormat("###,###.#", "en_US").format(sliderValue.toInt())}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w600),
                                          gradient: LinearGradient(
                                              colors: [widget.color2, widget.color1]),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${widget.currency} 3,400',
                                          style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyText1!
                                                  .color),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  SliderTheme(
                                    data: SliderThemeData(
                                        trackHeight: 4,
                                        activeTrackColor: Theme.of(context).canvasColor,
                                        trackShape: GradientRectSliderTrackShape(
                                            gradient: LinearGradient(
                                                colors: [widget.color2, widget.color1]),
                                            darkenInactive: false),
                                        overlayShape: SliderComponentShape.noOverlay,
                                        thumbColor: widget.color1,
                                        thumbShape: CustomThumb(
                                            enabledThumbRadius: 3.5,
                                            disabledThumbRadius: 3,
                                            elevation: 0,
                                            pressedElevation: 0)),
                                    child: Slider(
                                        min: 0,
                                        max: 3400,
                                        value: sliderValue,
                                        onChanged: (value) {
                                          setState(() {
                                            sliderValue = value;
                                          });
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Month limit', style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Spacer(),
                      Option(title: 'Change PIN', icon: 'pin')
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Option(title: 'freeze card', icon: 'freeze'),
                      Option(title: 'customize', icon: 'customize'),
                      Option(title: 'manage', icon: 'manage')
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
