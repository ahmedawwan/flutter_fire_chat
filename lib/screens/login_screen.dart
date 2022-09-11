import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/app_button.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'login_screen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential? user = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (user.user != null && mounted) {
        Navigator.pushNamed(context, ChatScreen.id);
      }
      setState(() {
        isLoading = false;
      });
    } catch (exception) {
      log(exception.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              AppTextField(
                textFieldColor: Colors.lightBlueAccent,
                hintText: 'Enter your email',
                textEditingController: emailController,
                obscureText: false,
              ),
              const SizedBox(
                height: 8.0,
              ),
              AppTextField(
                textFieldColor: Colors.lightBlueAccent,
                hintText: 'Enter your password',
                textEditingController: passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 24.0,
              ),
              AppButton(
                buttonText: 'Log in',
                backgroundColor: Colors.lightBlueAccent,
                onPressed: loginUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
