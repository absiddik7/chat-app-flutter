// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:messenger/home.dart';
import 'package:messenger/loginScreen/signup.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';

  static const failedSnackBar = SnackBar(
    content: Text('Login Failed!'),
    backgroundColor: Colors.red,
  );

  Future signIn(String userEmail, String userPassword) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword)
          .then((value) => {
                _emailController.clear(),
                _passwordController.clear(),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen())),
              });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(failedSnackBar);
    }
  }

  Future googleSignIn() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount =
        await googleSignIn.signIn().catchError((onError) => print(onError));

    GoogleSignInAccount? user;

    try {
      if (googleAccount != null) {
        user = googleAccount;
        final googleAuth = await googleAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .whenComplete(() {
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if (user == null) {
              print('User is currently signed out!');
            } else {
              String uid = user.uid;
              String? email = user.email;
              String? name = user.displayName;
              String? profilePic = user.photoURL;

              addUserDetails(uid, name!, email!, profilePic!);
            }
          });
        });
      } else {
        return;
      }
    } on PlatformException catch (err) {
      // Handle err
    } catch (err) {
      // other types of Exceptions
    }
  }

  Future addUserDetails(
      String userId, String userName, String userEmail, String profilePic) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(userId).set({
        'userId': userId,
        'name': userName,
        'email': userEmail,
        'profilepic':profilePic,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Messenger",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // email input field
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      width: deviceWidht * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Your Email',
                          border: InputBorder.none,
                        ),
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          } else if (EmailValidator.validate(value) != true) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    // password input field
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      width: deviceWidht * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Password',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Login button
              SizedBox(
                height: deviceHeight * 0.06,
                width: deviceWidht * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                    onPressed: () async {
                      var email = _emailController.text;
                      var password = _passwordController.text;

                      if (_formKey.currentState!.validate()) {
                        try {
                          await signIn(email, password);
                        } catch (e) {
                          throw Exception(e);
                        }
                      } else {}
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 12.0,
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
                    child: const Text('LOGIN'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an Account?"),
                  GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                          //decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              const Text('or'),
              const SizedBox(height: 10),
              SizedBox(
                // Google Login button
                height: deviceHeight * 0.06,
                width: deviceWidht * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SignInButton(
                    Buttons.GoogleDark,
                    text: "Sign in with Google",
                    onPressed: () async {
                      try {
                        await googleSignIn();
                      } catch (e) {
                        print(e);
                      }

                      // google sing in method
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
