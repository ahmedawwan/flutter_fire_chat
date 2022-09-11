import 'dart:developer';

import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flash_chat_flutter/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/app_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static String id = 'register_screen';

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential? user = await _auth.createUserWithEmailAndPassword(
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
      setState(() {
        isLoading = false;
      });
      log(exception.toString());
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
                textFieldColor: Colors.blueAccent,
                hintText: 'Enter your email',
                textEditingController: emailController,
                obscureText: false,
              ),
              const SizedBox(
                height: 8.0,
              ),
              AppTextField(
                textFieldColor: Colors.blueAccent,
                hintText: 'Enter your password',
                textEditingController: passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 24.0,
              ),
              AppButton(
                buttonText: 'Register',
                backgroundColor: Colors.blueAccent,
                onPressed: registerUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
