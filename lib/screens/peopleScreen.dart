import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/main.dart';
import 'package:messenger/model/chatRoomModel.dart';
import 'package:messenger/model/userModel.dart';
import 'package:messenger/screens/chatRoomScreen.dart';
import 'dart:convert';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  var userData = FirebaseFirestore.instance.collection('users').snapshots();

  // @override
  // void initState() {
  //   currentUser();
  //   super.initState();
  //   setState(() {
  //     //getUserData();
  //   });
  // }

  currentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;

    DocumentSnapshot userInfo =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    UserModel userModel =
        UserModel.fromJson(userInfo.data() as Map<String, dynamic>);

    return userModel;
  }

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.$uid', isEqualTo: true)
        .where('participants.${targetUser.userId}', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // fetch exiting chatroom
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // create new chatroom
      ChatRoomModel newChatroom =
          ChatRoomModel(chatroomid: uuid.v1(), lastMessage: "", participants: {
        uid.toString(): true,
        targetUser.userId.toString(): true,
      });

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      chatRoom = newChatroom;
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'People',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // search field
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(29),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            StreamBuilder(
                stream: userData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      UserModel tappedUser = UserModel(
                        userId: snapshot.data?.docs[index]['userId'],
                        name: snapshot.data?.docs[index]['name'],
                        email: snapshot.data?.docs[index]['email'],
                      );

                      return ListTile(
                        onTap: () async {
                          ChatRoomModel? chatroomModel =
                              await getChatRoomModel(tappedUser);

                          if (chatroomModel != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatRoomScreen(
                                          targetUser: tappedUser,
                                          chatRoom: chatroomModel,
                                        )));
                          }
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg'),
                        ),
                        title: Text(snapshot.data?.docs[index]['name']),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
