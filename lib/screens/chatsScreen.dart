import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/db/firebaseHandler.dart';
import 'package:messenger/model/chatRoomModel.dart';
import 'package:messenger/model/userModel.dart';
import 'package:messenger/screens/chatRoomScreen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  currentUser() {
    final FirebaseAuth auths = FirebaseAuth.instance;
    final user = auths.currentUser;
    final uid = user?.uid;

    return uid;
  }

  @override
  Widget build(BuildContext context) {
    var chats = FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${currentUser()}", isEqualTo: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chats',
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
                stream: chats,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot chatRoomSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatRoomSnapshot.docs.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              chatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          Map<String, dynamic> participants =
                              chatRoomModel.participants!;

                          List participantsKeys = participants.keys.toList();
                          participantsKeys.remove(currentUser());

                          return FutureBuilder(
                              future: FirebaseHandler.getUserModelById(
                                  participantsKeys[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    UserModel targetUser =
                                        userData.data as UserModel;
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatRoomScreen(
                                                      targetUser: targetUser,
                                                      chatRoom: chatRoomModel,
                                                    )));
                                      },
                                      leading: const CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg'),
                                      ),
                                      title: Text(targetUser.name.toString()),
                                      subtitle: (chatRoomModel.lastMessage
                                                  .toString() !=
                                              "")
                                          ? Text(chatRoomModel.lastMessage
                                              .toString())
                                          : const Text(
                                              'Say hi to new friend!',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
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
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something Wrong!'),
                      );
                    } else {
                      return const Center(
                        child: Text('No chats!'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
