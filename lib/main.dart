import 'package:flutter/material.dart';
import 'package:flutterappfirebasepractice/screens/welcome_screen.dart';
import 'package:flutterappfirebasepractice/screens/login_screen.dart';
import 'package:flutterappfirebasepractice/screens/registration_screen.dart';
import 'package:flutterappfirebasepractice/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.black54),
//        ),
//      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        // When navigating to the "/" route, build the FirstScreen widget.
        LoginScreen.id: (context) => LoginScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
      //home: WelcomeScreen(),
    );
  }
}
