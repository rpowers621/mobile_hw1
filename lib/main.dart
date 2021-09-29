import 'package:splashscreen/splashscreen.dart';
import 'driver.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  get colors => null;

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 7,
      navigateAfterSeconds:  AppDriver(),
      image: Image.asset("assets/Rachel_Headshot.JPG",
        alignment: const Alignment(0.0,0.0)),
      photoSize: 100.0,
      loadingText: Text("Loading Powers"),

      loaderColor: Colors.amberAccent,
      gradientBackground: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.teal,
          Colors.amberAccent,
        ]
      )

    );
  }
}


