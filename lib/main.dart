import 'package:demo/providers/auth_provider.dart';
import 'package:demo/providers/profile_provider.dart';
import 'package:demo/providers/todo_provider.dart';
import 'package:demo/screens/auth/login.dart';
import 'package:demo/screens/auth/signup.dart';
import 'package:demo/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login and Sign Up',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Splashscreen(),
        initialRoute: '/',
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          //'/dashboard': (context) => HomePage(),
        },
      ),
    );
  }
}
