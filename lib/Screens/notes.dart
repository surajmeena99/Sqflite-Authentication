import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_auth_app/Models/note_model.dart';
import 'package:sqflite_auth_app/Screens/add_note.dart';
import 'package:sqflite_auth_app/sqflite_db.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  
  late DatabaseHelper dbHandler = DatabaseHelper();
  late Future<List<NoteModel>> notes;

  final title = TextEditingController();
  final content = TextEditingController();
  final searchKeyword = TextEditingController();

  @override
  void initState() {
    super.initState();
    notes = getAllNotes();
  }

  Future<List<NoteModel>> getAllNotes() {
    return dbHandler.getNotes();
  }

  //Search method here
  Future<List<NoteModel>> searchNote() {
    return dbHandler.searchNotes(searchKeyword.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      body: Column(
        children: [
          //Search Field here
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(8)
            ),
            child: TextFormField(
              controller: searchKeyword,
              onChanged: (value) {
                //When type something in search
                if (value.isNotEmpty) {
                  setState(() {
                    notes = searchNote();
                  });
                } else {
                  setState(() {
                    notes = getAllNotes();
                  });
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NoteModel>>(
              future: notes,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      // final item = items[index];
                      return ListTile(
                        subtitle: Text(DateFormat("yMd").format(
                          DateTime.parse(items[index].createdAt))
                        ),
                        title: Text(items[index].noteTitle),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            dbHandler.deleteNote(items[index].noteId!)
                              .whenComplete(() {
                                _refresh();
                              }
                            );
                          },
                        ),
                        onTap: () {
                          //When click on note
                          setState(() {
                            title.text = items[index].noteTitle;
                            content.text = items[index].noteContent;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          dbHandler.updateNote(
                                            title.text,
                                            content.text,
                                            items[index].noteId,
                                          ).whenComplete(() {
                                            _refresh();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text("Update"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ],
                                title: const Text("Update note"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
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
                                  ]
                                ),
                              );
                            }
                          );
                        },
                      );
                    }
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddNote())
          ).then((value) {
            if (value) {
              _refresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
