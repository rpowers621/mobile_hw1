import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _db = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      
      title: 'Powers Fan Page Home',
      home: readMessages(),
    );
  }
}
class readMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Home Page"),
      ),
      backgroundColor: Colors.teal,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('messages').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {

              return Container(
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.amberAccent,
                ),
                  child: Center(child: Text(document['message'])),
                  margin:EdgeInsets.all(5.0),

              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _signOut(context);
        },
        tooltip: 'Log Out',
        child: const Icon(Icons.logout),
      ),
    );
  }


  void _signOut(BuildContext context) async {
    return showDialog(context: context,
        builder: (context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text("Are you sure you'd like to log out?"),
        ),
        actions: <Widget>[
          TextButton(
          child: Text('Log out'),
          onPressed: () async {
          await _auth.signOut();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('User logged out.')));
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (con) => AppDriver()));
          ScaffoldMessenger.of(context).clearSnackBars();
          },
          ),

        ],
      );
    });


  }
}
