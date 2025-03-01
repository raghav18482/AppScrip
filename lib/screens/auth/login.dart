import 'package:demo/screens/auth/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home_page.dart';

class LoginPage extends StatelessWidget {

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
                Text(
                  "Log In",
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: authProvider.usernameLoginController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: authProvider.passwordLoginController,
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
                ElevatedButton(
                  onPressed: () async {
                    // Handle login logic here
                    await authProvider.login(context,authProvider.usernameLoginController.text, authProvider.passwordLoginController.text).then((id){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(userId: authProvider.id,)),
                      );
                    });
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Don’t have an account? Sign up',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}