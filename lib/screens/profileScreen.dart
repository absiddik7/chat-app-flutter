import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/loginScreen/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
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
            const Center(
              child: Text('Bill Gates',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=> const LoginScreen()));
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
      ),
    );
  }
}
