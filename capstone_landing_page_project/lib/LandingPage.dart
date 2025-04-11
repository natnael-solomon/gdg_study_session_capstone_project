import 'package:flutter/material.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Text("Hello World",style:TextStyle(
            fontSize: 40,
          )),
      ),
    );
  }
}
