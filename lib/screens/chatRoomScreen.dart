import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/main.dart';
import 'package:messenger/model/chatRoomModel.dart';
import 'package:messenger/model/messageModel.dart';
import 'package:messenger/model/userModel.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen(
      {super.key,
      required this.targetUser,
      //required this.userModel,
      required this.chatRoom});

  final UserModel targetUser;
  //final UserModel userModel;
  final ChatRoomModel chatRoom;
  //final User firebaseUser;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();

  currentUser() async {
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
          .collection("chatsroom")
          .doc(widget.chatRoom.chatroomid)
          .collection('messages')
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: const NetworkImage(
                  'https://pbs.twimg.com/profile_images/1564398871996174336/M-hffw5a_400x400.jpg'),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                TextField(
                  controller: messageController,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Enter message"),
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
