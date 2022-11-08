class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  String? lastMessageSender;
  DateTime? createTime;
  List<dynamic>? users;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      this.lastMessageSender,
      this.createTime,
      this.users});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    lastMessageSender = map["lastMessageSender"];
    createTime = map["createtime"].toDate();
    users = map["users"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "createtime": createTime,
      "users": users,
      "lastMessageSender":lastMessageSender,
    };
  }
}
