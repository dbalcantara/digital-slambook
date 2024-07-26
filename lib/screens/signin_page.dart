import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week8datapersistence/screens/friends.dart';
import '../providers/auth_provider.dart';
import 'signup_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';
import 'dart:async';



class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool showSignInErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/slambook_background.jpg'), // Background image
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/slambook_icon.png'), width: 200, height: 200),
                  heading,
                  usernameField,
                  passwordField,
                  showSignInErrorMessage ? signInErrorMessage : Container(),
                  submitButton, 
                  SizedBox(height: 30),
                  Text("\n───   or Sign in with Google Account   ───"),
                  SizedBox(height: 15),
                  googleSignInButton,
                  signUpButton,
                  
                ],
              ),
            )),
        )
      ),
    );
  }

  Widget get heading =>  Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Center(child: Text(
          "Welcome to Your Slambook",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center
        ),),
         Center(child:         
         Text(
          "Sign in to your account",
          style: TextStyle(fontSize: 15),
        ),) 

        ])
        
        
      );

  Widget get usernameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Username"),
              hintText: "juandelacruz"),
          onSaved: (value) => setState(() => username = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your username";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "******"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password";
            }
            return null;
          },
        ),
      );

  Widget get signInErrorMessage => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Invalid username or password",
          style: TextStyle(color: Colors.red),
        ),
      );

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          String message = await context
              .read<UserAuthProvider>()
              .signIn(username: username!, password: password!);

          setState(() {
            if (message.contains("Successfully signed in")) {
              showSignInErrorMessage = false;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  FriendsPage()));
            } else {
              showSignInErrorMessage = true;
            }
          });
        }
      },
      child: const Text("Sign In"));

  Widget get signUpButton => Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No account yet?"),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text("Sign Up"))
          ],
        ),
      ); 

      Widget get signinWith => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Row(children: [
          Divider(),
          Text("or Sign in with", style: TextStyle(color: Colors.red)),
          Divider(),          
          ])
        
      );
 

  Widget get googleSignInButton => IconButton(
      onPressed: () async {
        try {
          final user = await context.read<UserAuthProvider>().signInWithGoogle();
          if (user != null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>  FriendsPage()));
          }
        } catch (e) {
          print("Google sign-in failed: ${e.toString()}");
        }
      },
      icon: CircleAvatar(
          child: Image.asset(
            'assets/google_icon.png',
            width: 100,
            height: 100,
          ),
      ),);
}

                