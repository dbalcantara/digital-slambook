import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class FriendDetailsPage extends StatefulWidget {
  final String friendId;

  const FriendDetailsPage({Key? key, required this.friendId}) : super(key: key);

  @override
  _FriendDetailsPageState createState() => _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {
  File? imageFile;
  Permission permission = Permission.photos;
  PermissionStatus permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
    _loadImage();
  }

  void _listenForPermissionStatus() async {
    final status = await permission.status;
    setState(() => permissionStatus = status);
  }

  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image_path');
    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath);
      });
    }
  }

  Future<void> _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  @override
  Widget build(BuildContext context) {
    final friend = context.read<FriendsProvider>().friends.firstWhere((friend) => friend['id'] == widget.friendId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              Navigator.pushNamed(context, "/slambook");
            },
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.pushNamed(context, "/friends");
            },
          ),
        ],
        backgroundColor: Colors.purple.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/slambook_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: 
          Center(
          child: SingleChildScrollView(
          child:           
          Column(children: [
          Image.asset(
                  'assets/friend_details.png',
                  fit: BoxFit.fill
                ),  
          SizedBox(
            width: 350,
            height: 600,
            child: Card(
              color: Colors.white30,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        if (permissionStatus == PermissionStatus.granted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select Image Source'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text('Gallery'),
                                        onTap: () async {
                                          final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                          if (image != null) {
                                            setState(() {
                                              imageFile = File(image.path);
                                            });
                                            await _saveImagePath(image.path);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Padding(padding: EdgeInsets.all(8.0)),
                                      GestureDetector(
                                        child: Text('Camera'),
                                        onTap: () async {
                                          final image = await ImagePicker().pickImage(source: ImageSource.camera);
                                          if (image != null) {
                                            setState(() {
                                              imageFile = File(image.path);
                                            });
                                            await _saveImagePath(image.path);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          requestPermission();
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                        child: imageFile == null ? Icon(Icons.add_a_photo) : null,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(children: [
                    Row(
                      children: [
                        Expanded(child: Icon(Icons.person)),
                        const Expanded(child: Text("Name:", style: TextStyle(fontSize: 15))),
                        Expanded(child: Text(friend['name'], style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Icon(Icons.tag)),
                        const Expanded(child: Text("Nickname:", style: TextStyle(fontSize: 15))),
                        Expanded(child: Text(friend['nickname'], style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Icon(Icons.cake)),
                        const Expanded(child: Text("Age:", style: TextStyle(fontSize: 15))),
                        Expanded(child: Text(friend['age'], style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Icon(Icons.favorite)),
                        const Expanded(child: Text("Relationship Status:", style: TextStyle(fontSize: 15))),
                        Expanded(child: Text(friend['single'] ? 'Single' : 'Not Single', style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Icon(Icons.sentiment_satisfied)),
                        const Expanded(child: Text("Happiness Level:", style: TextStyle(fontSize: 15))),
                        Expanded(child: Text(friend['happiness'].toString(), style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Icon(Icons.flash_on)),
                        const Expanded(child: Text("Superpower:", style: TextStyle(fontSize: 15))),
                        Expanded(child: Text(friend['superpower'], style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Icon(Icons.format_quote)),
                        const Expanded(child: Text("Favorite Motto:", style: TextStyle(fontSize: 15))),
                        Expanded(child: Text(friend['motto'], style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                    ])),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Go Back"),
                      ),
                    ),
                    const SizedBox(height: 30),

                  ],
                ),
              ),
            ),
          ),            
          ])
)

        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade400,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.purple.shade400),
              title: Text('Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/friends");
              },
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.purple.shade400),
              title: const Text('Slambook'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/slambook");
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.purple.shade400),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/profile");
              },
            ),
          ],
        ),
      ),
    );
  }

  void requestPermission() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        imageFile = File(image.path);
                      });
                      await _saveImagePath(image.path);
                    }
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        imageFile = File(image.path);
                      });
                      await _saveImagePath(image.path);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


