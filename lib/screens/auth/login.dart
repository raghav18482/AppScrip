import 'package:demo/screens/auth/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/todo_provider.dart';
import '../../services/cache.dart';
import '../../services/common_services.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    "Login",
                    style: TextStyle(
                      fontSize: _isLarge ? 40 : 20,
                      color: _isLarge ? Colors.blue : Colors.black,
                    ),
                  ),
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
                    await authProvider.login(context,authProvider.usernameLoginController.text, authProvider.passwordLoginController.text).then((authToken){
                      Cache().getsharedprefs(authToken).then((userid) {
                        if (userid == null) {
                          CommonServices.showToast('Error: You don\'t have an account', Colors.red);
                          print("User ID not found");
                        }else{
                          final taskProvider = Provider.of<TodoProvider>(context, listen: false);
                          taskProvider.fetchAndStoreTodos();
                        }
                        int id =  int.tryParse(userid ?? '0')!;
                        print("id=>$id");
                        final screen = userid != null ?   HomePage(userId: id) :SignUpPage();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => screen));
                      });

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