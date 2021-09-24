
import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
/*class Loading extends StatefulWidget {
  @override
  State<Loading> creatState() => _loading();

  @override
  State<StatefulWidget> createState() {
    return _loading();
  }
}

class _loading extends State<Loading>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.teal,
        body: InkWell(
          child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.black),
                 ),
                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child:  Container(
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 30.0),
                             ),
                          ],
                      )),
                    ),
                    Expanded(
                      flex: 1,
                       child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                             CircularProgressIndicator(
                              valueColor:  AlwaysStoppedAnimation<Color>(
                                Colors.amberAccent),
                              ),
                               Padding(
                                padding: EdgeInsets.only(top: 20.0),
                               ),
                          ],
                       ),
                    ),
                  ],
                ),
              ],
          ),
        ),
    );
  }
}*/

