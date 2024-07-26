import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final Map<String, dynamic> currentUser = context.read<ProfileProvider>().profile[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
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
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column (children: [
                Image.asset(
                  'assets/profile_text.png',
                  fit: BoxFit.fill
                ),
                Card(
                margin: const EdgeInsets.all(15),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                        
                      if (currentUser == null || currentUser.isEmpty)
                        _noProfile(context)
                      else
                        _withProfile(currentUser, context),
                    ],
                  ),
                ),
              ),
              ])

            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentUser != null && currentUser.isNotEmpty) {
            Navigator.pushNamed(
              context, "/QR", arguments: currentUser);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No profile information available.')),
            );
          }
        },
        child: Icon(Icons.qr_code, color: Colors.purple.shade200),
        backgroundColor: Colors.purple.shade400,
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _noProfile(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Text(
          'No profile information found.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'DancingScript',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/profileForm');
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Create Profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade200, // Background color
          ),
        ),
      ],
    );
  }

  Widget _withProfile(Map<String, dynamic> currentUser, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Profile Info',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'DancingScript',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.person, color: Colors.purple.shade400),
          title: Text(
            'Name: ${currentUser['name']}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.tag, color: Colors.purple.shade400),
          title: Text(
            'Nickname: ${currentUser['nickname']}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.cake, color: Colors.purple.shade400),
          title: Text(
            'Age: ${currentUser['age']}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(currentUser['single'] ? Icons.favorite_border : Icons.favorite, color: Colors.purple.shade400),
          title: Text(
            'Relationship Status: ${currentUser['single'] ? 'Single' : 'Not Single'}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.sentiment_satisfied, color: Colors.purple.shade400),
          title: Text(
            'Happiness Level: ${currentUser['happiness']}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.flash_on, color: Colors.purple.shade400),
          title: Text(
            'Superpower: ${currentUser['superpower']}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ListTile(
          leading: Icon(Icons.format_quote, color: Colors.purple.shade400),
          title: Text(
            'Favorite Motto: ${currentUser['motto']}',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, "/profileUpdate", arguments: currentUser['id']);
            },
            icon: Icon(Icons.edit, color: Colors.white),
            label: Text('Update Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade400, // Background color
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
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
            title: const Text('Friends'),
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
}
