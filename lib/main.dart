import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'screens/card_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        title: 'Tinder Clone',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: CircleBorder(),
              minimumSize: Size.square(72)
            ),
          ),
        ),
      home: const MainScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/swipe': (context) => const MainScreen(initialIndex: 0),
        '/chatRoom': (context) => const MainScreen(initialIndex: 1),
        '/profile': (context) => const MainScreen(initialIndex: 2),
        },
      ),
    );
  }
}
