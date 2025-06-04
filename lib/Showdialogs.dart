import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAddPostDialog(BuildContext context) {
  final postController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final imageUrlController = TextEditingController();
  String error = '';

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add New Post'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: postController,
                    decoration: InputDecoration(labelText: 'Post Text'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  if (imageUrlController.text.trim().isNotEmpty)
                    Image.network(
                      imageUrlController.text.trim(),
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Text('Invalid image'),
                    ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () async {
                  final text = postController.text.trim();
                  final description = descriptionController.text.trim();
                  final location = locationController.text.trim();
                  final imageUrl = imageUrlController.text.trim();

                  if (text.isEmpty) {
                    setState(() {
                      error = 'Post text cannot be empty';
                    });
                    return;
                  } else if (location.isEmpty) {
                    setState(() {
                      error = 'Location cannot be empty';
                    });
                    return;
                  }

                  try {
                    // بناء الخريطة بدون وصف إذا كان فارغ
                    Map<String, dynamic> dataToAdd = {
                      'post': text,
                      'location': location,
                      'createdAt': Timestamp.now(),
                    };

                    if (description.isNotEmpty) {
                      dataToAdd['description'] = description;
                    }
                    if (description.isNotEmpty) {
                      dataToAdd['imageUrl'] = imageUrl;
                    }

                    await FirebaseFirestore.instance.collection('posts').add(dataToAdd);
                    Navigator.pop(context);
                  } catch (e) {
                    setState(() {
                      error = 'Failed to add post';
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
void showboolPostDialog(BuildContext context,String docId) {
  String selectedLanguage = '';
  String error = '';
  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('choose the language'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Dart',
                            groupValue: selectedLanguage,
                            onChanged: (String? value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            },
                          ),
                          Text('Dart'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Python',
                            groupValue: selectedLanguage,
                            onChanged: (String? value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            },
                          ),
                          Text('Python'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'C#',
                            groupValue: selectedLanguage,
                            onChanged: (String? value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            },
                          ),
                          Text('C#'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () async {
                  final lang = selectedLanguage;
                  try {
                    await FirebaseFirestore.instance.collection('posts').doc(docId).update({
                      "language": lang,
                    }
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    setState(() {
                      error = 'Failed to add post';
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}


// Post Details Page


void showEditPostDialog(BuildContext context, String docId, String currentText, String currentImageUrl, String currentDescription, String currentLocation,) {
  final postController = TextEditingController(text: currentText);
  final descriptionController = TextEditingController(text: currentDescription);
  final locationController = TextEditingController(text: currentLocation);
  final imageUrlController = TextEditingController(text: currentImageUrl);
  String error = '';

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Post'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: postController,
                    decoration: InputDecoration(labelText: 'Post Text'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  if (imageUrlController.text.trim().isNotEmpty)
                    Image.network(
                      imageUrlController.text.trim(),
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Text('Invalid image'),
                    ),
                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () async {
                  final updatedText = postController.text.trim();
                  final updatedDescription = descriptionController.text.trim();
                  final updatedLocation = locationController.text.trim();
                  final updatedImageUrl = imageUrlController.text.trim();
                  if (updatedText.isEmpty) {
                    setState(() {
                      error = 'Post text cannot be empty';
                    });
                    return;
                  }
                  try {
                    Map<String, dynamic> dataToUpdate = {
                      'post': updatedText,
                      'location': updatedLocation,
                      'editedAt': Timestamp.now(),
                    };
                    if (updatedDescription.isNotEmpty) {
                      dataToUpdate['description'] = updatedDescription;
                    } else {
                      dataToUpdate['description'] = FieldValue.delete();
                    }
                    if (updatedImageUrl.isNotEmpty) {
                      dataToUpdate['imageUrl'] = updatedImageUrl;
                    } else {
                      dataToUpdate['imageUrl'] = FieldValue.delete();
                    }

                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(docId)
                        .update(dataToUpdate);

                    Navigator.pop(context);
                  } catch (e) {
                    setState(() {
                      error = 'Failed to update post: $e';
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
