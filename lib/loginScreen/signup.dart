import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:messenger/home.dart';
import 'package:messenger/loginScreen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignupPage(title: 'Sign Up'),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});
  final String title;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';

  void successDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Success"),
      content: const Text("Your sign-up is successful"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static const successSnackBar = SnackBar(
    content: Text('SignUp Successful'),
    backgroundColor: Colors.green,
  );

  static const failedSnackBar = SnackBar(
    content: Text('SignUp Failed!'),
    backgroundColor: Colors.red,
  );

  // user sign up
  Future signUp(String name, String userEmail, String userPassword) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userEmail, password: userPassword)
          .then((value) => {
                // add user details
                FirebaseAuth.instance.currentUser?.uid,
                addUserDetails(
                    FirebaseAuth.instance.currentUser!.uid, name, userEmail),


                ScaffoldMessenger.of(context).showSnackBar(successSnackBar),
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

  Future addUserDetails(
      String userId, String userName, String userEmail) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(userId).set({
        'userId': userId,
        'name': userName,
        'email': userEmail,
        'profilepic':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGIItLko5CxR0mnm4afjCns7hzcGyJ_TXOErxPosjyr-HEWLNx6KmXq9_hywYIWIFuueM&usqp=CAU',
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidht = MediaQuery.of(context).size.width;
    String pass = '';
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "ShareBook",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // name input field
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter name',
                          border: InputBorder.none,
                        ),
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                    ),
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
                          icon: Icon(Icons.mail),
                          hintText: 'Enter Email',
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
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Enter Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onChanged: (text) {
                          pass = text;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                    // confirm password input field
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
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Confirm Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onChanged: (text) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else if (value != pass) {
                            return 'Password mismatch';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // SignUp button
              SizedBox(
                height: deviceHeight * 0.06,
                width: deviceWidht * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var name = _nameController.text;
                        var email = _emailController.text;
                        var password = _passwordController.text;

                        await signUp(name, email, password);
                      } else {
                        // do something
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 12.0,
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
                    child: const Text('SIGNUP'),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account!"),
                  GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        " Login Now",
                        style: TextStyle(
                          //decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
