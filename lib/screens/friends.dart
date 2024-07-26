import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../providers/auth_provider.dart';


class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final friendsProvider = context.watch<FriendsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
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
        child: friendsProvider.friends.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.person_add_alt_1,
                    color: Colors.purple.shade400,
                    size: 50.0,
                  ),
                  const Text(
                    "No friends yet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/slambook");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Go to Slambook"),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: friendsProvider.friends.length,
              itemBuilder: (context, index) {
                final friend = friendsProvider.friends[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(25.0),
                    leading: Icon(
                      Icons.person,
                      color: Colors.purple.shade400,
                      size: 30.0,
                    ),
                    title: Row(children: [Flexible (child: Text(
                      friend['name'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis
                    ))]),
                    subtitle: Row(children: [Flexible (child: Text(
                      friend['nickname'],
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      overflow: TextOverflow.ellipsis
                    ))]),
                    tileColor: Colors.purple.shade100,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/friendDetails',
                              arguments: friend['id'],
                            );
                          },
                          child: const Text("Details", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade300,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/friendUpdate',
                              arguments: friend['id'],
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            friendsProvider.deleteFriend(friend['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
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
      ),
    );
  }
}
