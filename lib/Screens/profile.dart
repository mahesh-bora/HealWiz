import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healwiz/Screens/splash.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import 'auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controllerUserId = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerBio = TextEditingController();
  // final TextEditingController _controllerDob = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File? _selectedImage;
  Future<void> _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');

    if (file != null) {
      setState(() {
        _selectedImage = File(file.path);
      });
    }
    // You might want to use the imageUrl or perform other actions with it
    // For example, display the image using Image.network(imageUrl)
  }

  Widget signOutButton() {
    return ElevatedButton(
      onPressed: () async {
        await Auth()
            .signOut(); // Replace Auth() with your actual authentication class
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Splash(),
          ),
        ); // Close the profile screen and return to the login screen
      },
      child: Text('Sign Out'),
    );
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(WebSocket.userAgent)
          .get();

      UserData userData = UserData(
        name: userSnapshot['name'],
        id: userSnapshot['id'],
        bio: userSnapshot['bio'],
      );

      setState(() {
        _controllerName.text = userData.name!;
        _controllerUserId.text = userData.id!;
        _controllerBio.text = userData.bio!;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text("Sign Out"));
  }

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Splash(),
      ),
    ); // Close the profile screen and return to the login screen
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () async {
        String imageUrl = '';
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        String uniqueFilename =
            DateTime.now().microsecondsSinceEpoch.toString();

        try {
          // Upload image to Firebase Storage
          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFilename);
          await referenceImageToUpload.putFile(File(_selectedImage!.path));

          // Get the download URL of the uploaded image
          imageUrl = await referenceImageToUpload.getDownloadURL();
        } catch (e) {
          print('Error uploading image: $e');
        }

        Map<String, String> dataToSave = {
          // 'email': _controllerEmail;
          'imageUrl': imageUrl,
          'name': _controllerName.text,
          'userId': _controllerUserId.text,
          'bio': _controllerBio.text,
        };

        await FirebaseFirestore.instance.collection('Users').add(dataToSave);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Details Saved'),
              content: const Text('Your details have been successfully saved.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      child: const Text("Save"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                      'https://placehold.co/300.png'), // Replace with actual image URL
                ),
                SizedBox(height: 20.0),
                Text(
                  _controllerName.text ??
                      'John Doe', // Replace with user's name
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Software Developer', // Replace with user's bio
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30.0),
                signOutButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
// return Scaffold(
//   key: _scaffoldKey,
//   appBar: AppBar(
//     title: Text('Profile'),
//   ),
//   body: FutureBuilder<UserData?>(
//       future: _fetchUserData(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData) {
//             UserData userData = snapshot.data! as UserData;
//             return Container(
//               color: Colors.white,
//               height: MediaQuery.of(context).size.height,
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                           radius: 60,
//                           backgroundImage: _selectedImage != null
//                               ? FileImage(_selectedImage!)
//                                   as ImageProvider<Object>?
//                               : AssetImage('assets/demo.avatar.jpg'),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         initialValue: userData.name,
//                         controller: _controllerName,
//                         decoration: InputDecoration(
//                             labelText: "Name",
//                             border: OutlineInputBorder(),
//                             hintText: 'Enter your Name'),
//                         // style: TextStyle(
//                         //   fontSize: 24,
//                         //   fontWeight: FontWeight.bold,
//                         //   color: Colors.black,
//                         // ),
//                       ),
//                       SizedBox(height: 15),
//                       SizedBox(height: 8),
//                       TextFormField(
//                         initialValue: userData.id,
//                         controller: _controllerUserId,
//                         decoration: InputDecoration(
//                             labelText: "Username",
//                             border: OutlineInputBorder(),
//                             hintText: 'Enter your Username'),
//                       ),
//                       SizedBox(height: 16),
//                       SizedBox(height: 8),
//                       TextFormField(
//                         initialValue: userData.bio,
//                         controller: _controllerBio,
//                         decoration: InputDecoration(
//                             labelText: "Bio",
//                             border: OutlineInputBorder(),
//                             hintText: 'Enter your Bio'),
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _submitButton(),
//                           SizedBox(
//                             width: 16,
//                           ),
//                           _signOutButton(),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           } else {
//             return const Center(
//               child: Text("Something went wrong"),
//             );
//           }
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       }),
// );
