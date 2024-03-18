import 'package:flutter/material.dart';
import 'package:sqflite_auth_app/Authtentication/login.dart';
import 'package:sqflite_auth_app/Screens/notes.dart';
import 'package:sqflite_auth_app/Screens/users.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My DashBoard"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple.shade300,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: (){
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())
                );
              }, 
              icon: const Icon(Icons.logout, color: Colors.white,)
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, color: Colors.white,),
                    SizedBox(width: 5,),
                    Text("Users",)
                  ],
                ),
              ),
              Tab(
                icon: Icon(Icons.note, color: Colors.white,),
                text: "Notes",
              )
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 5,
          ),
        ),
        body: const TabBarView(
          children: [
            MyUsers(),
            Notes()
          ],
        ),
      ),
    );
  }
}