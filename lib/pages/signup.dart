import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/driver.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}): super(key:key);


  @override
  _SignUpPageState createState() => _SignUpPageState();
}


  class _SignUpPageState extends State<SignUpPage> {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    late TextEditingController _emailController,
        _reEmailController,
        _passwordController,
        _rePasswordController,
        _firstnameController,
        _lastnameController;
    final _formKey = GlobalKey<FormState>();

    @override
    void initState() {
      _emailController = TextEditingController();
      _reEmailController = TextEditingController();
      _passwordController = TextEditingController();
      _rePasswordController = TextEditingController();
      _firstnameController = TextEditingController();
      _lastnameController = TextEditingController();

      super.initState();
    }

    @override
    void dispose() {
      _emailController.dispose();
      _reEmailController.dispose();
      _passwordController.dispose();
      _rePasswordController.dispose();
      _firstnameController.dispose();
      _lastnameController.dispose();

      super.dispose();


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up For Powers Fan Page"),
        ),
        backgroundColor: Colors.teal,
        body: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 6.0),
              TextFormField(
                autocorrect: false,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "EMAIL ADDRESS",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Email'),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                autocorrect: false,
                controller: _reEmailController,
                validator: (value) {
                  if (value == null || value != _reEmailController.text) {
                    return 'Email addresses do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "RE ENTER EMAIL ADDRESS",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Re-Enter Email'),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                autocorrect: false,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "ENTER PASSWORD",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Password'),
              ),
              const SizedBox(height:6.0),
              TextFormField(
                autocorrect: false,
                controller: _rePasswordController,
                validator: (value) {
                  if (value == null || value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "VERIFY PASSWORD",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Verify Password'),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                autocorrect: false,
                controller: _firstnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Firstname",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Firstname'),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                autocorrect: false,
                controller: _lastnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lastname cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Lastname",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Lastname'),
              ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Loading Data')));

                    setState(() {
                      signUp();
                    });
                  }
                },
                child: const Text('Submit'),
              )
            ])));
  }
  Future<void> signUp() async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      _db
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "first_name": _firstnameController.text,
        "last_name": _lastnameController.text,
        "role" : 'customer',
        "registration_deadline" : DateTime.now(),
      })
          .then((value) => null)
          .onError((error, stackTrace) => null);
      Navigator.pushReplacement(context,MaterialPageRoute(builder:  (con) => AppDriver()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error")));
    } catch (e) {
      print(e);
    }

    setState(() {});
  }
}

