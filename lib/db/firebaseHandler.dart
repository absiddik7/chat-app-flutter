import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/model/userModel.dart';

class FirebaseHandler {
  Future getUserList() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    List userList = [];

    // Future getDocId() async {
    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .get()
    //       .then((QuerySnapshot querySnapshot) {
    //     for (var doc in querySnapshot.docs) {
    //       userList.add(doc.reference.id);
    //     }
    //   });
    // }

    try {
      // await users.doc().get().then((querySnapshot) => null);

      // FirebaseFirestore.instance
      //     .collection('users')
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //   for (var doc in querySnapshot.docs) {
      //     userList.add(doc.reference.id);
      //   }
      // });

      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          userList.add(doc.reference.id);
        }
        return userList;
      });

      print("db : ${userList.length}");
      //return userList;
    } catch (e) {
      //
    }
  }

  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(docSnap.data() != null) {
      userModel = UserModel.fromJson(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }
}
