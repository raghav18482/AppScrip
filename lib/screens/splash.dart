import 'dart:io';
import 'package:demo/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/cache.dart';
import '../services/common_services.dart';
import 'auth/login.dart';
import 'auth/signup.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>  with TickerProviderStateMixin {

  bool isLogin = false;
  bool _visible = false;
  double _containerSize = 0.0;
  final cacheInstance = Cache();

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _visible = true;
      _containerSize = MediaQuery.of(context).size.height;
    });
  }

  Future checkloginstatus() async {
    Cache().getsharedprefs('auth_token').then((authToken){
      String? userId;
      if(authToken == null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        return;
      }
      Cache().getsharedprefs(authToken).then((userid) {
        if (userid != null) {
          userId = userid;
        } else {
          CommonServices.showToast('Error: You don\'t have an account', Colors.red);
          print("User ID not found");
        }
        int id =  int.tryParse(userId ?? '0')!;

        print("id=>$id");
        final screen = userid != null ?   HomePage(userId: id) :SignUpPage();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => screen));

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration:  const Duration(seconds: 3),
        opacity: _visible ? 1.0 : 0.9,
        child: Container(
          padding: const EdgeInsets.all(30),
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(18,15,17,1),
          ),
          child:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/animation.gif', fit: BoxFit.contain),
          ),
        ),
        onEnd: (){
          checkloginstatus();
        },
      ),
    );
  }

}
