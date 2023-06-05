import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: ListView(
        children: [
          SizedBox(height: 50),
          // profile pic
          Icon(
            Icons.person,
            size: 72,
          ),

          SizedBox(height: 10),

          // user email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),

          SizedBox(height: 50),

          // user details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'My Details',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),

          // username
          MyTextBox(
            text: 'FavreLeandro',
            sectionName: 'username',
            onPressed: () {},
          )

          // bio

          // user posts
        ],
      ),
    );
  }
}
