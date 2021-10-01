import 'adminhome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signup.dart';
import 'loading.dart';
import '/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}): super(key: key);
  @override
  State<SignIn> createState() => _LoginState();
}

class _LoginState extends State<SignIn>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController, _passwordController;

  get model => null;

  @override
  void initState(){
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  bool _loading =false;
  String _password = '';
  String _email = '';

  @override
  Widget build(BuildContext context){
    final eInput = TextFormField(
      autocorrect: false,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
      decoration: const  InputDecoration(
        labelText: "Email Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
        hintText: "Enter Email"),
    );
    final pInput = TextFormField(
    autocorrect: false,
    controller: _passwordController,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return "Please enter your password";
    }
    return null;
    },
    obscureText: true,
    decoration: const  InputDecoration(
    labelText: "Password",
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))),
    hintText: "Enter Password",
      suffixIcon: Padding(
        padding: EdgeInsets.all(20),
        child: Icon(Icons.lock_rounded),
      )
      ,

    ),
    );
    final submit = OutlinedButton(
        onPressed:(){
          if(_formKey.currentState!.validate()){
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Loading Data')));
            _email = _emailController.text;
            _password = _passwordController.text;

            _emailController.clear();
            _passwordController.clear();

            setState(() {
              _loading = true;
              login();
            });
          }
        },
        child: const Text('Submit',
            style: TextStyle(
                color: Colors.amberAccent)),
    );
    final signin = OutlinedButton(
        onPressed: (){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => const SignUpPage()));
        },
        child: const Text('Sign Up',
          style: TextStyle(
            color: Colors.amberAccent)
          ));
    final google = IconButton(
      icon: Image.asset('assets/googleicon.png'),
        iconSize: 20,
        onPressed: (){
           signInWithGoogle();
        }, );

    return Scaffold(
        backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _auth.currentUser != null
              ? CircularProgressIndicator()
                :_loading
                  ? Loading()
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget> [
                          eInput,
                          pInput,
                          submit,
                          signin,
                          google
                        ],
                      )
            ),

          ]
        )
      ),
          floatingActionButton: FloatingActionButton(
            onPressed: _signOut,
            tooltip: 'Log out',
            child: const Icon(Icons.logout),
          ) ,
      );
  }

  Future<void> login() async {
    await Firebase.initializeApp();
      try{
        UserCredential uid = await _auth.signInWithEmailAndPassword(
            email: _email,
            password: _password);
        checkRole();

      }on FirebaseAuthException catch(e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Wrong password")));
        }else if(e.code =='user-not-found')    {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("User not found")));
        }
      }catch (e){
        print(e);
      }
      setState(() {
        _loading = false;
      });
  }
  void checkRole() async{
    FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get().then((value){
      if(value.data()!['role'] == 'ADMIN'){
        Navigator.pushReplacement(context,MaterialPageRoute(builder:  (con) => AdminHome()));
      }else{
        Navigator.pushReplacement(context,MaterialPageRoute(builder:  (con) => AppDriver()));
      }
    });
  }

  void _signOut() async {
      ScaffoldMessenger.of(context).clearSnackBars();
      if(_auth.currentUser != null) {
        await _auth.signOut();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("User logged out")));
      }else{
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No user logged in")));
      }
      setState(() {

      });
  }



  void  signInWithGoogle() async {
    // await Firebase.initializeApp();
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(credential);
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('first_name', isEqualTo: googleUser.displayName)
        .limit(1)
        .get();
    print(result.docs);
    print(googleUser.email);
    final List <DocumentSnapshot> docs = result.docs;
    if (docs.isEmpty) {
      try {

        _db
            .collection("users")
            .doc()
            .set({
          "first_name": googleUser.displayName,
          "last_name": '',
          "role": 'customer',
          "registration_deadline": DateTime.now(),
        })
            .then((value) => null)
            .onError((error, stackTrace) => null);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (con) => AppDriver()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      } catch (e) {
        print(e);
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (con) => AppDriver()));
    }
  }
  }

