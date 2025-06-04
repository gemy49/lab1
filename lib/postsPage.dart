import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/postDetailsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Showdialogs.dart';
import 'main.dart';

class PostsPage extends StatelessWidget {
  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts'),actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () => signOut(context),
          tooltip: 'Sign Out',
        ),
      ],),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error loading posts'));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text('No posts found'));

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final postText = data['post'] ?? '';
              final postdescription   = data['description'] ?? '';
              final postlocation = data['location'] ?? '';
              final imageUrl = data['imageUrl'] ?? '';
              final lang = data['language'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(postText),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailsPage(
                            text: postText,
                            imageUrl: imageUrl,
                            description: postdescription,
                            location: postlocation,
                            bool: lang,
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){showboolPostDialog(context,doc.id);}, icon:Icon(Icons.info) ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showEditPostDialog(context, doc.id, postText, imageUrl, postdescription, postlocation);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Are  you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text('cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text('delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(doc.id)
                                    .delete();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('delete filed : $e')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );


        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddPostDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}