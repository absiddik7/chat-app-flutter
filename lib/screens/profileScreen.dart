import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/loginScreen/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:messenger/model/userModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = true;

  //UserModel userModel = UserModel();
  String userId = '';
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    getUserData();
    super.initState();
    setState(() {
      //getUserData();
    });
  }

  getUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          print('name: ${data['name']}');
          setState(() {
            userName = data['name'];
          });
          // return Text("Full Name: ${data['name']} ${data['email']}");
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
// builder
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              return const Text("Something went wrongggggg");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              print('name: ${data['name']}');
              // setState(() {
              //   userName = data['name'];
              // });
              // return Text("Full Name: ${data['name']} ${data['email']}");

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg'),
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
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
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
                            ListTile(
                              leading: const Icon(Icons.logout),
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
