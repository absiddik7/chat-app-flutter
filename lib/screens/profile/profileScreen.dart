import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/loginScreen/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/screens/profile/editProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = true;
  bool isDarkMode = false;
  bool isLoading = false;
  String userId = '';
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    //getUserData();
    super.initState();
    setState(() {});
  }

  currentUser() {
    final FirebaseAuth auths = FirebaseAuth.instance;
    final user = auths.currentUser;
    final uid = user?.uid;
    return uid;
  }

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong!");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("User does not exist!");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(data['profilepic']),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //user name
                    Center(
                      child: Text(data['name'],
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            // Account
                            ListTile(
                              leading: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              title: const Text('Account',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              subtitle: Text(data['email']),
                            ),
                            // Account Setting
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileScreen(
                                                    name: data['name'])))
                                    .then((value) => setState(() {}));
                              },
                              leading: const Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              title: const Text('Account Setting',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                            // dark/light mode button
                            ListTile(
                              leading: const Icon(
                                Icons.dark_mode,
                                color: Colors.black,
                              ),
                              title: const Text('Dark Mode',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              trailing: Switch(
                                value: isDarkMode,
                                onChanged: (value) {
                                  setState(() {
                                    isDarkMode = value;
                                    print(isDarkMode);
                                  });
                                },
                                activeTrackColor: Colors.orange[200],
                                activeColor: Colors.deepOrange,
                              ),
                            ),
                            // active button
                            ListTile(
                              leading: const Icon(
                                Icons.circle,
                                color: Colors.green,
                              ),
                              title: const Text('Active Status',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              trailing: Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    print(isSwitched);
                                  });
                                },
                                activeTrackColor: Colors.blue[200],
                                activeColor: Colors.blue,
                              ),
                            ),

                            // Logout button
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              title: GestureDetector(
                                  onTap: () async {
                                    final googleSignIn = GoogleSignIn();
                                    await googleSignIn.signOut();
                                    FirebaseAuth.instance
                                        .signOut()
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    });
                                  },
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  )),
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
