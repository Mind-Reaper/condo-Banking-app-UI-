import 'package:condo/providers/chat_bot_provider.dart';
import 'package:condo/providers/state_provider.dart';
import 'package:condo/providers/theme_provider.dart';
import 'package:condo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/security.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> ThemeProvider()),
        ChangeNotifierProvider(create: (context)=> StateProvider()),
        ChangeNotifierProvider(create: (context)=> ChatBotProvider()),
      ],
      child: App()
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Condo',
      debugShowCheckedModeBanner: false,
      themeMode:  Provider.of<ThemeProvider>(context).darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: Provider.of<ThemeProvider>(context).darkMode?Provider.of<ThemeProvider>(context).dark:  Provider.of<ThemeProvider>(context).light,
      routes: {

        '/security': (context)=> Security(),
        '/home': (context)=> Home(),
      },
      home: Builder( builder: (context) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(data: mediaQueryData.copyWith(textScaleFactor: 1, ), child: Security());
      },

    )
    );
  }
}
