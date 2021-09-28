
import 'package:cloud_firestore/cloud_firestore.dart';

import '/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _db = FirebaseFirestore.instance;
String _inputText = '';

class AdminHome extends StatefulWidget {
  AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}


class _AdminHomeState extends State<AdminHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Admin Home Page"),
          backgroundColor: Colors.amberAccent,
          actions: <Widget>[
           FlatButton(
              onPressed: (){
                _add(context);
                },
                child: const Icon(Icons.add)
            )
          ]
        ),

        backgroundColor: Colors.amberAccent,
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
                    height: 50,
                    padding: EdgeInsets.all(2.0),
                    color: Colors.teal,
                    child: Center(child: Text(document['message'])),
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


  final TextEditingController _textFieldController = TextEditingController();

  void _add(BuildContext context) async{
    return showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(hintText: "Enter message"),
            ),
            actions: <Widget>[
              OutlinedButton(
                  onPressed: (){
                    setState(() {
                      addMessageToDB();
                      Navigator.pop(context);
                    });
                  },
                   child: const Text('Post Message'))
            ],
          );
        });
  }


Future<void> addMessageToDB() async {
    _db
        .collection("messages")
        .doc()
        .set({
      "message":  _textFieldController.text,
      "registration_deadline" : DateTime.now(),

    });
    setState(() {
      _textFieldController.clear();
    });
}

}
