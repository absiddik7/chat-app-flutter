import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/main.dart';
import 'package:messenger/model/chatRoomModel.dart';
import 'package:messenger/model/messageModel.dart';
import 'package:messenger/model/userModel.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen(
      {super.key, required this.targetUser, required this.chatRoom});

  final UserModel targetUser;
  final ChatRoomModel chatRoom;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();

  currentUser() {
    final FirebaseAuth auths = FirebaseAuth.instance;
    final user = auths.currentUser;
    final uid = user?.uid;

    return uid;
  }

  sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: currentUser(),
        text: msg,
        seen: false,
        createdon: DateTime.now(),
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .collection('messages')
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomid)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    var messeges = FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .orderBy("createdon", descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage:  NetworkImage(
                 widget.targetUser.profilepic.toString()),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.name.toString()),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder(
                  stream: messeges,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: ((context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment:
                                    (currentMessage.sender == currentUser())
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                currentUser())
                                            ? Colors.blue
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      )),
                                ],
                              );
                            }));
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something Wrong!'),
                        );
                      } else {
                        return const Center(
                          child: Text('Say hi!'),
                        );
                      }
                    } else {
                      return const Center(
                          //child: CircularProgressIndicator(),
                          );
                    }
                  }),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Message"),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
