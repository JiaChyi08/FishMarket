import 'dart:convert';

import 'package:flutter/material.dart';
import 'order.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List _orderdetails;
  String titlecenter = "Loading order details...";
  double screenHeight, screenWidth;
 
  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(230, 255, 250, 10),
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
        title: Text('Order Details',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
         padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
        child: Column(children: <Widget>[
          Text(
            "Order Details",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _orderdetails == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Color.fromRGBO(44, 133, 155, 50),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount:
                          _orderdetails == null ? 0 : _orderdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                               child: Container(
                                              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(3, 3, 5, 3),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: "https://lowtancqx.com/s270964/FishMarket/images/${_orderdetails[index]['prid']}.png",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                              _orderdetails[index]['prname'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                               )
                                            ),
                                          Expanded(
                                            flex: 3,
                                            child: Text("x "+
                                              _orderdetails[index]['qty'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text("RM "+
                                             double.parse(_orderdetails[index]['prprice']).toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            flex: 4,
                                          ),
                                        ],
                                      ),
                                    ))));
                      }))
        ]),
      ),
    ));
  }

  _loadOrderDetails() async {
     http.post(
      Uri.parse(
        "https://lowtancqx.com/s270964/FishMarket/php/load_carthistory.php")
    , body: {
      "orderid": widget.order.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}