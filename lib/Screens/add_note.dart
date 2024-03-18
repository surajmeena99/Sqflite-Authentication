import 'package:flutter/material.dart';
import 'package:sqflite_auth_app/Models/note_model.dart';
import 'package:sqflite_auth_app/sqflite_db.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  final title = TextEditingController();
  final content = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create note"),
        actions: [
          IconButton(
            onPressed: () {
              //Add Note button (Done)
              if (formKey.currentState!.validate()) {
                dbHelper.addNote(
                  NoteModel(
                    noteTitle: title.text,
                    noteContent: content.text,
                    createdAt: DateTime.now().toIso8601String(),  //...
                  )
                ).whenComplete(() {
                  Navigator.of(context).pop(true);
                });
              }
            },
            icon: const Icon(Icons.check)
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: title,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              TextFormField(
                controller: content,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Content is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text("Content"),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
