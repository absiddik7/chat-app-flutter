import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/loginScreen/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = true;
  bool isLoading = false;

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

  currentUser() {
    final FirebaseAuth auths = FirebaseAuth.instance;
    final user = auths.currentUser;
    final uid = user?.uid;

    return uid;
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
          setState(() {
            userName = data['name'];
          });
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  File? imageFile;
  CroppedFile? croppedImage;

  void selectImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: imageSource);

    if (image != null) {
      //cropImage(image);
      imageFile = File(image.path);
    }
  }

  void cropImage(XFile imageFile) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    if (croppedImage != null) {
      setState(() {
        //croppedImage = croppedImage;
        //imageFile = File(croppedImage.path);
      });
    }
  }

  uploadImage() async {
    isLoading = true;
    if (imageFile != null) {
      UploadTask upoadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(currentUser())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await upoadTask;
      String? imageUrl = await snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(currentUser()).update({
        'profilepic': imageUrl,
      }).whenComplete(() => setState(() {
            isLoading = false;
          }));
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
          // actions: <Widget>[
          //   TextButton(
          //     child: const Text('Approve'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
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
              return const Text("Something went wrong!");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("User does not exist!");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                        child: GestureDetector(
                      onTap: () {
                        // update profile pic
                        photoChoosOption();
                      },
                      child: Container(
                        child: (isLoading)
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    NetworkImage(data['profilepic']),
                              ),
                      ),
                    )),
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
                            TextButton(
                                onPressed: () async {
                                  await uploadImage();
                                },
                                child: const Text('save')),
                            ListTile(
                              leading: const Icon(
                                Icons.circle,
                                color: Colors.green,
                              ),
                              // active button
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
                            // Logout button
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
