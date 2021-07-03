import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:mhl_fishmarket/paymenthistory.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhl_fishmarket/user.dart';
import 'paymenthistory.dart';
import 'loginscreen.dart';
import 'cartpage.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>  {
  String _titlecenter = "Loading...";
  List _productList = [];
  double screenHeight, screenWidth;
  SharedPreferences prefs;
  int cartitem = 0;
  TextEditingController _srcController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(230, 255, 250, 10),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/MHL.png',
            fit: BoxFit.contain,
            height: 55,
            ),
            Container(
              padding: const EdgeInsets.all(0.1),
              child: 
                 Text('MHL Fish Market', style:TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.bold)),
            )]
            ),
            flexibleSpace: Container(
                  decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Colors.blue[200],
                Colors.lightGreen[200],
              ]
            ))),
        actions: [
          TextButton.icon(
              onPressed: () => {_goToCart()},
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              label: Text(
                cartitem.toString(),
                style: TextStyle(color: Colors.black),
              )),
        ],
            iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(child: ListView(  
          // Important: Remove any padding from the ListView.  
          padding: EdgeInsets.zero,  
          children: <Widget>[  
            UserAccountsDrawerHeader(  
                decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                  Colors.blue[200],
                  Colors.lightGreen[200],
                 ]
              )),
              accountEmail: Text('${widget.user.email}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),  
              currentAccountPicture: CircleAvatar(  
                backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.blue[200]
                    : Colors.lightGreen[200], 
                backgroundImage: AssetImage(
              "assets/images/profile.png",),  
              ),  
            ),  
            ListTile(  
              leading: Icon(Icons.home), title: Text("Fish List",style: TextStyle(fontSize:16)),  
              onTap: () {  
                Navigator.pop(context); 
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: widget.user)));
              } 
            ), 
             ListTile(  
              leading: Icon(Icons.shopping_cart), title: Text("My Cart",style: TextStyle(fontSize:16)),  
              onTap: () {  
                Navigator.pop(context);  
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartPage(user: widget.user)));
              }  
            ),  
             ListTile(  
              leading: Icon(Icons.shopping_basket_rounded), title: Text("Order History",style: TextStyle(fontSize:16)),  
              onTap: () {  
                Navigator.pop(context);  
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => PaymentHistoryScreen(user: widget.user)));
              },  
            ),  
             
            /*ListTile(  
              leading: Icon(Icons.contacts), title: Text("Contact Us"),  
              onTap: () {  
                Navigator.pop(context);  
              },    
            ), */
            Divider(thickness: 2,),
            ListTile(
            leading: Icon(Icons.logout), title: Text("Logout",style: TextStyle(fontSize:16)), 
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      title: Text("Log out the account?"),
                      content: Text("Are you sure?"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => LoginScreen()));
                          },
                        ),
                        TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ]
                      );});}
        
      ), 
    ],  
  ),
    ),
      body: Center(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _srcController,
                      decoration: InputDecoration(
                        hintText: "Search product",
                        suffixIcon: IconButton(
                          onPressed: () => _loadProduct(_srcController.text),
                          icon: Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.white10)),
                      ),
                    )
                  ],
                )),
            if (_productList.isEmpty)
              Flexible(child: Center(child: Text(_titlecenter)))
            else
              Flexible(
                  child: OrientationBuilder(builder: (context, orientation) {
                return StaggeredGridView.countBuilder(
                    padding: EdgeInsets.all(10),
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    itemCount: _productList.length,
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(
                        children: [
                          Container(
                            //color: Colors.red,
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height:
                                          orientation == Orientation.portrait
                                              ? 100
                                              : 150,
                                      width: orientation == Orientation.portrait
                                          ? 100
                                          : 150,
                                     child: CachedNetworkImage(
                                        imageUrl: "https://lowtancqx.com/s270964/FishMarket/images/${_productList[index]['prid']}.png",
                                     )),
                                    Text(
                                      titleSub(
                                          _productList[index]['prname']),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Qty:" +
                                        _productList[index]['prqty']),
                                    Text("RM " +
                                        double.parse(
                                                _productList[index]['prprice'])
                                            .toStringAsFixed(2),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
                                    Container(
                                      child: ElevatedButton(
                                        onPressed: () => {_addToCart(index)},
                                        child: Text("Add to Cart",style: TextStyle(color: Colors.black)),
                                        style: ElevatedButton.styleFrom(
                                        primary: Colors.lightBlueAccent[100],
                                        onPrimary: Colors.white,
                                        shadowColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }))
          ],
        ),
      ),
    );
  }

  String titleSub(String title) {
    if (title.length > 14) {
      return title.substring(0, 14) + "...";
    } else {
      return title;
    }
  }


  _loadProduct(String prname) {
    http.post(
      Uri.parse("https://lowtancqx.com/s270964/FishMarket/php/loadproduct.php"),
        body: {"prname": prname}).then((response) {
      if (response.body == "nodata") {
        _titlecenter = "No product";
        _productList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
        _titlecenter = "";
      }
      if(!mounted){
        return;
      }
      setState(() {});
    });
  }

    Future<void> _testasync() async {
    _loadProduct("");
    _loadCart();
  }


  _addToCart(int index) async {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: Text("Add to cart"), title: Text("Progress..."));
      progressDialog.show();
      await Future.delayed(Duration(seconds: 1));
      String prid = _productList[index]['prid'];
      http.post(Uri.parse("https://lowtancqx.com/s270964/FishMarket/php/insertcart.php"),
        body: {"email": widget.user.email, "prid": prid}).then((response) {
        print(response.body);
        if (response.body == "failed") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed',style:TextStyle(fontWeight: FontWeight.bold ))
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully Added to Cart',style:TextStyle(fontWeight: FontWeight.bold ))
          ));
          _loadCart();
        }
      });
      progressDialog.dismiss();
    }

  _goToCart() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => CartPage(user: widget.user)));
    _loadProduct("");
  }


void _loadCart() {
    http.post(Uri.parse("https://lowtancqx.com/s270964/FishMarket/php/loadcartitem.php"),
        body: {"email": widget.user.email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }
}
