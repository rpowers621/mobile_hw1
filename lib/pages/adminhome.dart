
import 'package:cloud_firestore/cloud_firestore.dart';

import '/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _db = FirebaseFirestore.instance;

class AdminHome extends StatefulWidget {
  AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}


class _AdminHomeState extends State<AdminHome> {
  List<String> messages =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Powers Fan Page"),
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
        body: Container( child: ListView.builder(
            padding: const EdgeInsets.all(8),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index){
              return Container (
              height: 50,
               color: Colors.teal,
               child: Center(child: Text('${messages[index]}')),
              );
              }

        ),),
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              FloatingActionButton(
                onPressed: () {
                  _signOut(context);
                },
                tooltip: 'Log out',
                child: const Icon(Icons.lock),
              ),
            ]
        )
    );
  }

  void _signOut(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    await _auth.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('User logged out.')));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (con) => AppDriver()));
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
      "message": _textFieldController.text,
      "registration_deadline" : DateTime.now(),

    });
    setState(() {
      readMessage();
    });
}
  void readMessage() async {
    FirebaseFirestore.instance.collection('messages')
        .get()
        .then((value) {
      if (value.size > 0 ) {
        for (var element in value.docs) {
          messages.add(element["message"]);
        }
      }
    });
    setState(() {

    });
  }
}
