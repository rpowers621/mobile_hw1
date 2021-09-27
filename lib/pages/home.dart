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

  List<String> messages =[];

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body:
        Container( child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index){
            return Container (
              height: 50,
              color: Colors.amberAccent,
              child: Center(child: Text('${messages[index]}')),

            );

          }

      ),),
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
    ScaffoldMessenger.of(context).clearSnackBars();
    await _auth.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('User logged out.')));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (con) => AppDriver()));
  }


}