import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger/screens/profileScreen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.name});
  final name;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isSwitched = true;
  bool isLoading = false;
  final editNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editNameController.text = widget.name;
    // Change the cursor position
    editNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: editNameController.text.length));
  }

  currentUser() {
    final FirebaseAuth auths = FirebaseAuth.instance;
    final user = auths.currentUser;
    final uid = user?.uid;
    return uid;
  }

  File? imageFile;

  void selectImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: imageSource);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  updateData() async {
    isLoading = true;
    if (imageFile != null) {
      UploadTask upoadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(currentUser())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await upoadTask;
      String? imageUrl = await snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(currentUser()).update({
        'name': editNameController.text,
        'profilepic': imageUrl,
      });
    } else {
      FirebaseFirestore.instance.collection('users').doc(currentUser()).update({
        'name': editNameController.text,
      });
    }
  }

  photoChoosOption() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Profile Photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text('Choose from Gallary'),
                ),
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text('Take Photo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                updateData();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.check,
                color: Colors.black,
              )),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
              future: users.doc(uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong!");
                } else if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("User does not exist!");
                } else if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                            child: GestureDetector(
                          onTap: () {
                            // update profile pic
                            photoChoosOption();
                          },
                          child: Container(
                            child: (imageFile != null)
                                ? CircleAvatar(
                                    radius: 85,
                                    backgroundImage: FileImage(imageFile!),
                                  )
                                : CircleAvatar(
                                    radius: 85,
                                    backgroundImage:
                                        NetworkImage(data['profilepic']),
                                  ),
                          ),
                        )),
                        const Text(
                          'Change Profile Photo',
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        ),
                        const SizedBox(height: 30),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.grey,
                  ),
                );
              }),
          //user name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "UserName",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
                controller: editNameController,
                style: const TextStyle(fontSize: 18)),
          )),
        ],
      ),
    );
  }
}
