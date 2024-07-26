import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert'; // For JSON decoding
import 'package:week8datapersistence/screens/qr_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';





final List<String> _dropdownOptions = [
  "Makalipad",
  "Maging Invisible",
  "Mapaibig siya",
  "Mapabago ang isip niya",
  "Mapalimot siya",
  "Mabalik ang nakaraan",
  "Mapaghiwalay sila",
  "Makarma siya",
  "Mapasagasaan siya sa pison",
  "Mapaitim ang tuhod ng iniibig niya"
];

final List<String> _mottoList = [
  "Haters gonna hate",
  "Bakers gonna Bake",
  "If cannot be, borrow one from three",
  "Less is more, more or less",
  "Better late than sorry",
  "Don't talk to strangers when your mouth is full",
  "Let's burn the bridge when we get there"
];

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool single = false;
  double happiness = 5.0;
  String? superpower;
  String? motto;
  String summaryText = '';
  File? imageFile;
  Permission permission = Permission.photos;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
    String? _result; 

  @override
  void initState() {
    super.initState();
    motto = _mottoList[0];
    superpower = _dropdownOptions[0];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Setup"),
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
      backgroundColor: Colors.purple.shade400,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/slambook_background.jpg'), // Background image
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: SingleChildScrollView(
            child:  Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/profile_setup.png',
                          fit: BoxFit.fill
                        ),
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
                            radius: 40,
                            backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                            child: imageFile == null ? Icon(Icons.add_a_photo) : null,
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildSeparatedFields(),
                        const SizedBox(height: 5),
                        _buildCenteredSection(
                          "Happiness Level",
                          "On a scale of 0 (hopeless) to 5 (very happy), how would you rate your current lifestyle",
                          Slider(
                            value: happiness,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: happiness.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                happiness = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        _buildCenteredSection(
                          "Superpower",
                          "If you were to have a superpower, what would it be",
                          _buildDropdown(),
                        ),
                        const SizedBox(height: 5),
                        _buildCenteredSection(
                          "Motto",
                          "Select your favorite motto",
                          _buildMottoRadios(),
                        ),
                        if (summaryText.isNotEmpty) _buildSummarySection(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildButton("Reset", _resetForm, Colors.white),
                            const SizedBox(width: 20),
                            _buildButton("Submit", _submitForm, Colors.purple.shade200),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
          
          ),      
          ),
        ),
      ),

      drawer: _buildDrawer(context),
    );
  }

  void setResult(String result) {
    setState(() {
       _result = result;
    });
    print(result);
  final RegExp regex = RegExp(r"(\w+):\s*([\s\S]*?)\n", multiLine: true);
  final Map<String, dynamic> resultMap = {};

  final matches = regex.allMatches(result);

  for (final match in matches) {
    final String key = match.group(1)?.toLowerCase() ?? ''; // Ensure keys are in lowercase
    final String value = match.group(2)?.trim() ?? '';
    
    switch (key) {
      case 'happiness':
        resultMap[key] = int.tryParse(value) ?? 0; // Convert to int, default to 0 if parsing fails
        break;
      case 'single':
        resultMap[key] = value.toLowerCase() == 'true'; // Convert to bool
        break;
      default:
        resultMap[key] = value; // Keep as String
        break;
    }
  }

  // final mapString = resultMap.entries.map((e) {
  //   if (e.value is String) {
  //     return "'${e.key}' : '${e.value}'";
  //   } else {
  //     return "'${e.key}' : ${e.value}"; // For int and bool
  //   }
  // }).join(',\n'); 
    // final mapData = jsonDecode(resultMap) as Map<String, dynamic>;
    context.read<FriendsProvider>().addFriend(resultMap);

    
    // context.read<FriendsProvider>().addFriend(friendData);
  }

  


  Widget _buildSeparatedFields() {
    return Column(
      children: [
        _buildCard(
          child: _buildTextField(nameController, 'Name', Icons.person),
        ),
        const SizedBox(height: 5),
        _buildCard(
          child: _buildTextField(nicknameController, 'Nickname', Icons.tag),
        ),
        const SizedBox(height: 5),
        _buildCard(
          child: _buildTextField(
            ageController,
            'Age',
            Icons.cake,
          ),
        ),
        const SizedBox(height: 5),
        _buildCard(
          child: _buildSwitchTile(),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(icon ),
        filled: true,
        fillColor: Colors.purple.shade100.withOpacity(0.5),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Age') {
        final age = int.tryParse(value);
        if (age == null || age <= 0) {
          return 'Please enter a valid age';
        }
      }
        return null;
      },
    );
  }

  Widget _buildSwitchTile() {
    return SwitchListTile(
      title: const Text("Are you single?"),
      value: single,
      onChanged: (bool value) {
        setState(() {
          single = value;
        });
      },
      secondary: Icon(
        single ? Icons.favorite : Icons.favorite_border,
        color: Colors.purple.shade400,
        ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }

  Widget _buildCenteredSection(String title, String subtitle, Widget child) {
    return Center(
      child: _buildCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: superpower,
      items: _dropdownOptions.map((power) => DropdownMenuItem(
        value: power,
        child: Row(
          children: [
            Icon(Icons.flash_on, color: Colors.deepPurple),
            const SizedBox(width: 5),
            Text(power),
          ],
        ),
      )).toList(),
      onChanged: (value) {
        setState(() {
          superpower = value;
        });
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildMottoRadios() {
    return Column(
      children: _mottoList.map((mottoList) => RadioListTile<String>(
        title: Text(mottoList),
        value: mottoList,
        groupValue: motto,
        onChanged: (value) {
          setState(() {
            motto = value;
          });
        },
        secondary: Icon(Icons.format_quote),
      )).toList(),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: Text(text),
    );
  }

  void _resetForm() {
    setState(() {
      nameController.clear();
      nicknameController.clear();
      ageController.clear();
      single = false;
      happiness = 5.0;
      superpower = _dropdownOptions[0];
      motto = _mottoList[0];
      summaryText = '';
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'name': nameController.text,
        'nickname': nicknameController.text,
        'age': ageController.text,
        'single': single,
        'happiness': happiness,
        'superpower': superpower,
        'motto': motto,
      };

      setState(() {
        summaryText =
            "Name: ${nameController.text}\n"
            "Nickname: ${nicknameController.text}\n"
            "Age: ${ageController.text}\n"
            "Relationship Status: ${single ? 'Single' : 'Not Single'}\n"
            "Happiness Level: ${happiness.round()}\n"
            "Superpower: $superpower\n"
            "Motto: $motto";
      });
      context.read<ProfileProvider>().addProfile(userData);
      // Provider.of<FriendsProvider>(context, listen: false).saveUserData(userData);
      Navigator.pop(context);
    }
  }

  Widget _buildSummarySection() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Divider(thickness: 2, color: Colors.purple.shade400,),
            const SizedBox(height: 5),
             Text(
              "Summary",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.purple.shade400,),
            ),
            const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,                                
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,                           
                        children: [
                          Text(                                                         // labels
                              "Name:",                                                          
                              style: TextStyle(fontSize: 15)),
                              const SizedBox(width: 70),                                              
                              Text(
                              "Nickname:",                                                      
                              style: TextStyle(fontSize: 15)),
                              //const SizedBox(width: 70), 
                              Text(
                              "Age:",                                                           
                              style: TextStyle(fontSize: 15)),
                              //const SizedBox(width: 70),
                              Text(
                              "Relationship Status:",                                           
                              style: TextStyle(fontSize: 15)),
                              //const SizedBox(width: 70), 
                              Text(
                              "Happiness Level: ",                                              
                              style: TextStyle(fontSize: 15)),
                              //const SizedBox(width: 70), 
                              Text(
                              "Superpower:",                                                   
                              style: TextStyle(fontSize: 15)),
                              //const SizedBox(width: 70), 
                              Text(
                              "Favorite Motto:",                                                
                              style: TextStyle(fontSize: 15)),
                              //const SizedBox(width: 70), 
                        ],
                      ),
                      const SizedBox(width: 20), 
                      Column(                                                           // friend data
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Text('${nameController.text}', style: const TextStyle(fontSize: 15)), 
                          Text('${nicknameController.text}', style: const TextStyle(fontSize: 15)), 
                          Text('${ageController.text}', style: const TextStyle(fontSize: 15)), 
                          Text(single ? 'Single' : 'Not Single', 
                              style: const TextStyle(fontSize: 15)),
                          Text('${happiness.round()}'.toString(), 
                              style: const TextStyle(fontSize: 15)),
                          Text('$superpower', style: const TextStyle(fontSize: 15)), 
                          Text('$motto', style: const TextStyle(fontSize: 15)), 
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 5),
             Divider(thickness: 2, color: Colors.purple.shade400),

          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
            color: Colors.purple.shade400,            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading:  Icon(Icons.people, color: Colors.purple.shade400),
            title:  Text('Friends'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/friends");
            },
          ),
          ListTile(
            leading:  Icon(Icons.book, color: Colors.purple.shade400),
            title: const Text('Slambook'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/slambook");
            },
          ),
          ListTile(
            leading:  Icon(Icons.person, color: Colors.purple.shade400),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile");
            },
          ),
        ],
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