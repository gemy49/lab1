import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDetailsPage extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String description;
  final String location;
  final String bool;

  const PostDetailsPage({required this.text, required this.imageUrl, required this.description, required this.location,required this.bool});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Post data", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text(
                      'Title: $text',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    if(description.isNotEmpty)
                      Text(
                        'description: $description',
                        style: TextStyle(fontSize: 18),
                      ),
                    Text(
                      'location: $location',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text("Post Votes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text(
                      bool=="Dart"?'language: Dart (1)':'language: Dart (0)',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      bool=="Python"?'language: Python (1)':'language: Python (0)',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      bool=="C#"?'language: C# (1)':'language: C# (0)',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),

                    SizedBox(width: double.infinity, ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}