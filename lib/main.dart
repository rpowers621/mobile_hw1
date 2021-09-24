import 'package:splashscreen/splashscreen.dart';
import 'driver.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SomethingWentWrong();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Splash();
            } else {
              return Container(color: Colors.white);
            }
          },
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
    );
  }
}
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    title: "Splash Screen",
    theme: ThemeData (
      primarySwatch: Colors.lightGreen,
    ),
    home: Splash_info(),
    debugShowCheckedModeBanner: false,
  );
}
}
class Splash_info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 7,
      navigateAfterSeconds:  AppDriver(),
      title: new Text('Check Out Powers',  textScaleFactor: 2,),
      image: new Image.asset("assets/Rachel_Headshot.JPG"),
      loadingText: Text("Loading Powers"),
      photoSize: 100.0,
      loaderColor: Colors.amberAccent,
      backgroundColor: Colors.teal,
    );
  }
}


