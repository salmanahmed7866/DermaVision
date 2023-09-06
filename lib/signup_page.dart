import "package:apitest/utils.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:apitest/login_page.dart";
import "package:apitest/survey_form.dart";
import "package:velocity_x/velocity_x.dart";
import "package:apitest/rounded_button.dart";
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Utils util = Utils();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Padding(
        padding: EdgeInsets.only(right: 40),
        child: Center(child: Text("SignUp")),
      )),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    //label: Text("Email"),
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "field is empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    //label: Text("Email"),
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "field is empty";
                    }
                    return null;
                  },
                ),
              ],
            )),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RoundedButton(
            title: "SignUp",
            loading: loading,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                _auth
                    .createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString())
                    .then((value) {
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error ${error.toString()}'),
                    backgroundColor: Colors.deepOrangeAccent.shade100,
                  ));
                  setState(() {
                    loading = false;
                  });
                });
              }
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account?"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()));
                },
                child: Text("Login"))
          ],
        )
      ]),
    );
  }
}
