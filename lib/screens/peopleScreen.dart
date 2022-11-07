import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/db/firebaseHandler.dart';
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
  currentUser() {
    final FirebaseAuth auths = FirebaseAuth.instance;
    final user = auths.currentUser;
    final uid = user?.uid;
    return uid;
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
    var userData = FirebaseFirestore.instance
        .collection('users')
        .where("userId", isNotEqualTo: currentUser())
        .snapshots();
    List<UserModel> allUsers = [];
    List ids = [];

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
                textInputAction: TextInputAction.go,
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
                      UserModel userModel = UserModel.fromJson(
                          snapshot.data?.docs[index].data()
                              as Map<String, dynamic>);

                      allUsers.add(userModel);
                      ids.add(userModel.userId);

                      UserModel tappedUser = UserModel(
                        userId: snapshot.data?.docs[index]['userId'],
                        name: snapshot.data?.docs[index]['name'],
                        email: snapshot.data?.docs[index]['email'],
                      );

                      return FutureBuilder(
                          future: FirebaseHandler.getUserModelById(ids[index]),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.done) {
                              if (userSnapshot.data != null) {
                                UserModel users = UserModel();
                                if (userSnapshot.data?.userId !=
                                    currentUser()) {
                                  users = userSnapshot.data as UserModel;
                                }
                                return ListTile(
                                  onTap: () async {
                                    ChatRoomModel? chatroomModel =
                                        await getChatRoomModel(tappedUser);

                                    if (chatroomModel != null) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatRoomScreen(
                                                    targetUser: tappedUser,
                                                    chatRoom: chatroomModel,
                                                  )));
                                    }
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                        users.profilepic.toString()),
                                  ),
                                  title: Text(users.name.toString()),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          });
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
