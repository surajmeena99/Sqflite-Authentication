import 'package:flutter/material.dart';
import 'package:sqflite_auth_app/Models/users_model.dart';
import 'package:sqflite_auth_app/sqflite_db.dart';

class MyUsers extends StatefulWidget {
  const MyUsers({super.key});

  @override
  State<MyUsers> createState() => _MyUsersState();
}

class _MyUsersState extends State<MyUsers> {

  late DatabaseHelper dbHandler = DatabaseHelper();
  late Future<List<Users>> users;

  @override
  void initState() {
    super.initState();
    users = getAllUsers();
  }

  Future<List<Users>> getAllUsers() {
    return dbHandler.getUsers();
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      users = getAllUsers();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: users, 
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
                final item = items[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(item.usrId.toString()),
                  ),
                  title: Text(item.usrName),
                  subtitle: Text(item.usrPassword),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      dbHandler.deleteUser(item.usrId!)
                        .whenComplete(() {
                          _refresh();
                        }
                      );
                    },
                  ),
                );
              }
            );
          }
        },
      ),
    );
  }
}