import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MainScreen',style:TextStyle(color:Colors.black)),
        backgroundColor: Color.fromRGBO(56, 230, 219, 50),
      ),
      body: Center(
        child: Container(
          child: Text('Welcome to MHL Fresh Fish Market'),
        ),
      ),
    );
  }
}