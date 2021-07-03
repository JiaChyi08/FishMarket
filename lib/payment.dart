import 'dart:async';

import 'package:flutter/material.dart';
import 'user.dart';
import 'mainscreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayScreen extends StatefulWidget {
  final User user;

  const PayScreen({Key key, this.user}) : super(key: key);

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(user: widget.user)));
      },
    child: Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
         color: Colors.black, //change your color here
         ),
         flexibleSpace: Container(
                  decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Colors.blue[200],
                Colors.lightGreen[200],
              ]
            ))),
        title: Text('Payment',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'https://lowtancqx.com/s270964/FishMarket/php/generate_bill.php?email=' +
                          widget.user.email +
                          '&mobile=' +
                          widget.user.phone +
                          '&name=' +
                          widget.user.name +
                          '&amount=' +
                          widget.user.amount,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}