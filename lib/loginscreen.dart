import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registrationscreen.dart';
import 'mainscreen.dart';
import 'user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
   bool _obscureText = true;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences prefs;

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MHL Fresh Fish Market',
      home: Scaffold(
         body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
          ),
        ),
        Center(
          child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(70, 5, 70, 0),
                  child:
                      Image.asset('assets/images/MHL.png', scale: 1)),
              SizedBox(height: 5),
              Card(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
	                ),
                color: Colors.lightBlue[50],
                margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email)),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password', icon: Icon(Icons.lock), 
                            suffix: InkWell(
                          onTap: _togglePass,
                          child: Icon(Icons.visibility),
                        )),
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: 5),
                  
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                         child: Text("Forgot Password?", style: TextStyle(fontSize: 13,fontWeight:FontWeight.w500)),
                         onTap: _forgotPassword,
                        ),
                      ),

                      Row(
                        children: [
                          Checkbox(
                              value: _rememberMe,
                              onChanged: (bool value) {
                                _onChange(value);
                              }),
                          Text("Remember Me",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w500)),
                        ],
                      ),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minWidth: 200,
                          height: 40,
                          child: Text('LOGIN',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight:FontWeight.bold,
                              )),
                          onPressed: _onLogin,
                          color: Colors.lightBlueAccent),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                GestureDetector(
                child: Text("Don't have an Account?",
                    style: TextStyle(fontSize: 16,color: Colors.black)),
                onTap: _registerNewUser,
              ),
               GestureDetector(
                child: Text("Register",
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                onTap: _registerNewUser,
              ),
              SizedBox(height: 10),
            ],
          ),
            ])),
      ),
      ]
      )));
  }

  void _onLogin() {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    http.post(
        Uri.parse("https://lowtancqx.com/s270964/FishMarket/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
      print(response.body);
      if (response.body == "success") {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Success',style:TextStyle(fontWeight: FontWeight.bold ))
          ));

        Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen(user: User(
                                  email: _emailController.text,
                                  ),)));
      } else {
        Fluttertoast.showToast(
            msg: "Login  Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegistrationScreen()));
  }

 void _forgotPassword() {
    TextEditingController _useremailcontroller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Forgot Your Password?"),
            content: Container(
                height: 100,
                child: Column(
                  children: [
                    Text("Enter your recovery email"),
                      TextField(
                      controller: _useremailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email),
                        ),
                    )
                  ],
                )),
            actions: [
              TextButton(
                child: Text("Submit", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  print(_useremailcontroller.text);
                  _resetPassword(_useremailcontroller.text.toString());
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _onChange(bool value) {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();

    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/password is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      _rememberMe = value;
      storePref(value, _email, _password);
    });
  }
 
  Future<void> storePref(bool value, String email, String password) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await prefs.setString("email", '');
      await prefs.setString("password", '');
      await prefs.setBool("rememberme", value);
      Fluttertoast.showToast(
          msg: "Preferences removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(191, 30, 46, 50),
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    _rememberMe = prefs.getBool("rememberme") ?? false;

    setState(() {
      _emailController.text = _email;
      _passwordController.text = _password;
    });
  }

  void _resetPassword(String emailreset) {
    http.post(
        Uri.parse("https://lowtancqx.com/s270964/FishMarket/php/forgot_password.php"),
        body: {"email": emailreset}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Password reset completed. Please check your email for futher instruction.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Password reset failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromRGBO(191, 30, 46, 50),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
     void _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}