import 'package:condo/providers/theme_provider.dart';
import 'package:condo/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

import 'dart:io' show Platform;

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  String passcode = '';
  var localAuth = LocalAuthentication();
  bool canCheckBiometrics = false;
  String security = 'touchid';
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBiometrics();
  }

  checkBiometrics() async {
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          setState(() {
            security = 'faceid';
          });
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          setState(() {
            security = 'touchid';
          });
        }
      }
    }
  }

  Future<bool> authenticate() async {
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed', options: AuthenticationOptions(biometricOnly: true));
    return didAuthenticate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
            )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Security screen',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 48),
                Text(
                  'Enter your passcode',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText1!
                      .copyWith(fontSize: 16),
                ),
                SizedBox(height: 10),
                ShakeMe(
                  key: shakeKey,
                  shakeCount: 3,
                  shakeOffset: 10,
                  shakeDuration: Duration(milliseconds: 500),
                  child: Container(
                    height: 48,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: passcode.length >= index + 1 ? 14 : 12,
                              width: passcode.length >= index + 1 ? 14 : 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: passcode.length >= index + 1
                                      ? Colors.green
                                      : Color(0xff8E8E93)),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(height: 48),
                Container(
                  width: 312,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 16),
                      itemCount: passcodes.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String item = passcodes[index];
                        return Material(
                          color: item != 'unlock' && item != 'delete'
                              ? Theme.of(context).cardColor
                              : Theme.of(context).primaryColor,
                          shape: CircleBorder(),
                          child: InkWell(
                            customBorder: CircleBorder(),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.green.withOpacity(0.3),
                            onTap: () async {
                              if (item == 'unlock') {
                                authenticate().then((value) async {
                                  if (value) {
                                    setState(() {
                                      passcode = '0000';
                                    });
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/home', (route) => route.isCurrent);
                                  }
                                });
                              } else if (item == 'delete') {
                                if (passcode.length > 0) {
                                  passcode = passcode.substring(
                                      0, passcode.length - 1);
                                  setState(() {});
                                }
                              } else {
                                setState(() {
                                  if (passcode.length < 4) {
                                    passcode = '$passcode$item';
                                  }
                                  if (passcode.length == 4) {
                                    if (passcode == '0000') {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          '/home', (route) => route.isCurrent);
                                    } else {
                                      shakeKey.currentState?.shake();
                                      Vibrate.feedback(FeedbackType.error);
                                      passcode = '';
                                    }
                                  }
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              height: 75,
                              width: 75,
                              child: FittedBox(
                                  child: item == 'unlock'
                                      ? ImageIcon(
                                          AssetImage(
                                              'assets/images/$security.png'),
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        )
                                      : item == 'delete'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ImageIcon(
                                                AssetImage(
                                                    'assets/images/delete.png'),
                                              ),
                                            )
                                          : Text(
                                              item,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .button,
                                            )),
                            ),
                          ),
                        );
                      }),
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passcode is 0000')));
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 16),
                    )),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ));
  }
}
