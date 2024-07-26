import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

// Dropdown options for superpowers
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

// Favorite motto options
final List<String> _mottoList = [
  "Haters gonna hate",
  "Bakers gonna Bake",
  "If cannot be, borrow one from three",
  "Less is more, more or less",
  "Better late than sorry",
  "Don't talk to strangers when your mouth is full",
  "Let's burn the bridge when we get there"
];

class  ProfileUpdatePage extends StatefulWidget {
  final String friendId;

  const  ProfileUpdatePage({Key? key, required this.friendId}) : super(key: key);

  @override
   _ProfileUpdatePageState createState() =>  _ProfileUpdatePageState();
}

class  _ProfileUpdatePageState extends State< ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>(); 
  late TextEditingController nameController; 
  late TextEditingController nicknameController; 
  late TextEditingController ageController; 
  bool single = false; 
  double happiness = 5.0;
  String? superpower; 
  String? motto; 

  @override
  void initState() {
    super.initState();
    // initializations for the data
    final user = context.read<ProfileProvider>().profile[0];
    nameController = TextEditingController(text: user['name']);
    nicknameController = TextEditingController(text: user['nickname']);
    ageController = TextEditingController(text: user['age']);
    single = user['single'];
    happiness = user['happiness'].toDouble();
    superpower = user['superpower'];
    motto = user['motto'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Friend Details"), 
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
            image: AssetImage('assets/slambook_background.jpg'), // Background image
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
        child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // form key for validation
          child: Column(
          children: [
            Image.asset(
              'assets/profile_update.png',
              fit: BoxFit.fill
            ),
            Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.purple.shade100.withOpacity(0.5),                  
                    ),
                  readOnly: true, // disables textfield
                ),
              ),
            ),
            Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nicknameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nickname',
                    prefixIcon: Icon(Icons.tag),
                    filled: true,
                    fillColor: Colors.purple.shade100.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your nickname'; // error message
                    }
                    return null;
                  },
                ),
              ),
            ),
          Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Age',
                          prefixIcon: Icon(Icons.cake),
                          filled: true,
                          fillColor: Colors.purple.shade100.withOpacity(0.5),                        
                          ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age'; // error message if input is empty
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number'; // error message if input is not a valid number
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ),
          Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SwitchListTile(
              title: const Text("Are you single?"),
              value: single, // current value
              onChanged: (bool value) {
              setState(() {
                single = value;
              });
            },
              secondary: Icon(
              single ? Icons.favorite : Icons.favorite_border,
              color: Colors.purple.shade400,
             ),
          ),
        ),
          ),
        Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                children: [
                  Text("Happiness Level", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  const SizedBox(height: 15),
                  Text("On a scale of 0 (hopeless) to 10 (very happy), how would you rate your current lifestyle", 
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
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
                ],
              ),
            ),
        ),
          Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
            padding: const EdgeInsets.all(20),
            child:  Column(
                children: [
                  Text("Superpower", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  const SizedBox(height: 15),
                  Text("If you were to have a superpower, what would it be", 
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                  ),
              DropdownButtonFormField<String>(
                value: superpower,
                items: _dropdownOptions.map((power) => DropdownMenuItem(
                  value: power,
                  child: Text(power),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    superpower = value;
                  });
                },
              ),
                ],
              ),
            ),
        ),
              Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                children: [
                  const Text("Motto", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Text("Select your favorite motto", 
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                  ..._mottoList.map((mottoList) => RadioListTile<String>(
                    title: Text(mottoList),
                    value: mottoList,
                    groupValue: motto,
                    onChanged: (value) {
                      setState(() {
                        motto = value!;
                      });
                    },
                  )),
                ],
              ),
            ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final friendData = {
                          'nickname': nicknameController.text,
                          'age': ageController.text, // Ensure age is int
                          'single': single,
                          'happiness': happiness,
                          'superpower': superpower,
                          'motto': motto,
                        };
                        context.read<ProfileProvider>().updateProfile(widget.friendId, friendData);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade200,
                    ),
                    child: const Text("Update", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),),
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
    ),
    );
  }
}
