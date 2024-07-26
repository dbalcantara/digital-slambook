import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week8datapersistence/screens/friends.dart';
import 'package:week8datapersistence/screens/friends_details.dart';
import 'package:week8datapersistence/screens/friends_update.dart';
import 'package:week8datapersistence/screens/slambook.dart';
import 'package:week8datapersistence/screens/signin_page.dart';
import 'package:week8datapersistence/screens/profile_page.dart';
import 'package:week8datapersistence/screens/generate_qr_page.dart';
import 'package:week8datapersistence/screens/profile_form.dart';
import 'package:week8datapersistence/screens/profile_update.dart';
import 'package:week8datapersistence/screens/signin_page.dart';
import 'package:week8datapersistence/screens/signup_page.dart';



import 'firebase_options.dart';
import 'providers/friends_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => FriendsProvider())),
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
        ChangeNotifierProvider(create: ((context) => ProfileProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          home: authProvider.user == null ? SignInPage() : FriendsPage(),
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                builder: (context) => authProvider.user == null
                    ? SignInPage()
                    : FriendsPage(),
              );
            }
            if (settings.name == '/slambook') {
              return MaterialPageRoute(
                builder: (context) => SlambookPage(),
              );
            }
            if (settings.name == '/friends') {
              return MaterialPageRoute(
                builder: (context) => FriendsPage(),
              );
            }
            if (settings.name == '/friendDetails') {
              final friendId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => FriendDetailsPage(friendId: friendId),
              );
            }
            if (settings.name == '/friendUpdate') {
              final friendId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => FriendUpdatePage(friendId: friendId),
              );
            }
            if (settings.name == '/QR') {
              final currentUser = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => QRCodePage(currentUser: currentUser),
              );
            }
            if (settings.name == '/profile') {
              // final profileId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => ProfilePage(),
              );
            }
            if (settings.name == '/profileForm') {

              return MaterialPageRoute(
                builder: (context) => ProfileFormPage(),
              );
            }
            if (settings.name == '/profileUpdate') {
              final userId = settings.arguments as String;              
              return MaterialPageRoute(
                builder: (context) => ProfileUpdatePage(friendId: userId),
              );
            }
            return null;
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}
