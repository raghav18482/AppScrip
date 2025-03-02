import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';


class SignUpPage extends StatefulWidget {

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  double _opacity = 0.0;
  bool _isLarge = false;

  @override
  void initState() {
    super.initState();
    // Start the animation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
        _isLarge = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(seconds: 1),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: _isLarge ? 40 : 20,
                      color: _isLarge ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: authProvider.usernameSignupController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: authProvider.passwordSignupController,
                  obscureText: !authProvider.passwordVisible,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          authProvider.passwordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          authProvider.visibility(authProvider.passwordVisible );
                        },
                      )
                  ),
                ),
                SizedBox(height: 20),
                authProvider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () async{
                    // Handle sign up logic here
                    await authProvider.signup(context,authProvider.usernameSignupController.text, authProvider.passwordSignupController.text);
                    // Navigate back to login page
                  },
                  child: Text('Sign Up'),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
