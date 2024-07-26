import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? username;
  String? email;
  String? password;
  List<String> contactNumbers = [];
  final contactNumberController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  heading,
                  nameField,
                  usernameField,
                  emailField,
                  passwordField,
                  contactNumberField,
                  addContactNumberButton,
                  contactNumbersList,
                  if (errorMessage != null) errorText,
                  submitButton,
                  backButton,
                ],
              ),
            )),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Name"),
              hintText: "Enter your full name"),
          onSaved: (value) => setState(() => name = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your name";
            }
            return null;
          },
        ),
      );

  Widget get usernameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Username"),
              hintText: "Enter a valid username"),
          onSaved: (value) => setState(() => username = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid username format";
            }
            return null;
          },
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              hintText: "Enter your email"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email";
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
              hintText: "At least 8 characters"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid password";
            }
            return null;
          },
        ),
      );

  Widget get contactNumberField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          controller: contactNumberController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Contact Number"),
              hintText: "Enter a contact number"),
        ),
      );

  Widget get addContactNumberButton => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: ElevatedButton(
            onPressed: () {
              if (contactNumberController.text.isNotEmpty) {
                setState(() {
                  contactNumbers.add(contactNumberController.text);
                  contactNumberController.clear();
                });
              }
            },
            child: const Text("Add Contact Number")),
      );

  Widget get contactNumbersList => Column(
        children: contactNumbers
            .map((number) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(number),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            contactNumbers.remove(number);
                          });
                        },
                      )
                    ],
                  ),
                ))
            .toList(),
      );

  Widget get errorText => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          errorMessage ?? '',
          style: TextStyle(color: Colors.red),
        ),
      );

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          final message = await context.read<UserAuthProvider>().signUp(
                name: name!,
                username: username!,
                email: email!,
                password: password!,
                contactNumbers: contactNumbers,
              );
          if (message.isNotEmpty) {
            setState(() {
              errorMessage = message;
            });
          } else {
            Navigator.pop(context);
            // Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const SignInPage()));
          }
        }
      },
      child: const Text("Sign Up"));

      Widget get backButton => ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
          child: const Text("Go Back"),
        );

}
