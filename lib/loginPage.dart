import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop/Navbar.dart';
import 'package:my_shop/listProduct.dart';
import 'package:my_shop/signup.dart';
import 'config/AppConfig.dart';
import 'service/login_service.dart';
import 'package:my_shop/util/http_exception_dialog.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flushbar/flushbar.dart';



class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Flushbar flush;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
   bool _loading = false;
  final LoginService loginservice = new LoginService();

   void userLogin(String userEmail, String userPassword) async {
    

    setState(() {
      _loading = true;
    });

    var url = AppConfig.apiUrl + AppConfig.login;

    Map<String, String> headers = {
    };
    Map<String, String> body = {
      'email' : userEmail,
      'password' : userPassword
    };


    var data;

    try {
      data = await loginservice.getUserLogin(url, headers, body, context);
      data = await data.transform(utf8.decoder).join();
    } catch(e) {

    }

    print(data);


    HttpExceptionDialog httpExceptionDialog = new HttpExceptionDialog();

    if (data == null) {
      print("the error is coming here");
      httpExceptionDialog.showAlertDialog(context, "Http Request Failed.");
    }

    Map<String, dynamic> user = jsonDecode(data);
    print(user);
     AppConfig.loginData = data;
     if(user['status'] != 200) { //// need to change things on this checkpoint
           setState(() {
             print("Login Failed");
             _loading = false;
                       flush= Flushbar<bool>(
                                mainButton: FlatButton(
                                  onPressed: (){
                                    flush.dismiss(true);
                                  },
                                  child: Text('OK',style: TextStyle(fontSize: 16.0, color: Colors.yellow, fontWeight: FontWeight.bold),),
                                ),
                                borderRadius: 10,
                                message: "email or password is incorect",
                                duration: Duration(seconds: 6),
                              )..show(context);
           });
           print("userrrr");
           print(user);
     } else {
       SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('tokenn', user['data']['token']);
    print("preffff");
    print(prefs);

                                     Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context) => new BottomNavBar()));

      
     }
  }

  Widget _entryFieldEmail(String title, {bool isPassword = false}) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (input) {
              if (input.isEmpty & !input.contains('@')) {
                return 'Provide an email';
              }
            },
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey)) ,

              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.black)),
            ),
            controller: loginEmailController,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }


   Widget _entryFieldPassword(String title, {bool isPassword = false}) {
     return Container(
       margin: EdgeInsets.symmetric(vertical: 10),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[

           TextField(

               decoration: InputDecoration(
                 hintText: 'Password',
                 hintStyle: TextStyle(color: Colors.black),
                 border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                     borderSide: BorderSide(color: Colors.grey)) ,

                 focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                     borderSide: BorderSide(color: Colors.black)),
               ),

               controller: loginPasswordController,
               obscureText: isPassword,

             style: TextStyle( fontSize: 15),

           )
         ],
       ),
     );
   }


  Widget _submitButton() {


    return ButtonTheme(
      height: 40,
      minWidth: 150,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),

        ),
        onPressed: (){
          userLogin(loginEmailController.text,loginPasswordController.text);
        },

        color: Colors.red[800],
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }



  Widget _logo() {
    return Container(
      child: Image.asset("assets/shop.png",height: 200,width: 200,),
    );
  }


  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFieldEmail("Email id",),
        _entryFieldPassword("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(key: _scaffoldKey,
        body: ModalProgressHUD(
           inAsyncCall: _loading,
                  child: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        _logo(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        _submitButton(),
                        GestureDetector(
                          onTap: (){
                          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context) => new SignUpPage()));

                          },
                                                child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Sign up',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
