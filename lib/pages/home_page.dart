import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/drawer.dart';
import 'package:the_wall/components/text_field.dart';
import 'package:the_wall/components/wall_post.dart';
import 'package:the_wall/helper/helper_methods.dart';
import 'package:the_wall/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // post message
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': []
      });
    }

    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  // navigato to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('The Wall'),
        elevation: 0,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            // the wall
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // get the message
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post["TimeStamp"]),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  // textfield
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Write something on the wall',
                      obscureText: false,
                    ),
                  ),

                  // post button
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  )
                ],
              ),
            ),

            // logged in as
            Text(
              "Logged in as: ${currentUser.email!}",
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
