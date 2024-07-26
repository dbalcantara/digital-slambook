import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  final Map<String, dynamic> currentUser;

  QRCodePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrData = 
        'name: ${currentUser['name']}\n'
        'nickname: ${currentUser['nickname']}\n'
        'age: ${currentUser['age']}\n'
        'single: ${currentUser['single']}\n'
        'happiness: ${currentUser['happiness']}\n'
        'superpower: ${currentUser['superpower']}\n'
        'motto: ${currentUser['motto']}\n';

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 300.0,
            gapless: false,
          ),
        ),
      ),
    );
  }
}
