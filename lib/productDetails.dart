import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_shop/myCart.dart';
import 'package:http/http.dart' as http;
import 'service/home_fragment_service.dart';
//import 'package:water/Screens/Cart.dart';
final HomeService homeservice = new HomeService();
int _n = 0;


class AddProduct extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat'
      ),

      home:ProductDetails(),
    );
  }
}

class ProductDetails extends StatefulWidget {
  String idd = "";
 ProductDetails({Key key, this.title,this.idd}) : super(key: key);

  final String title;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
   bool loading = true;
  List<dynamic> notList = new List();
  String categoryList;
  String descriptions;
  String title;
  String id;
  Map data;
  _makePatchRequest() async {
  // set up PATCH request arguments
  String url = "http://192.168.43.243:3000/MySHop/user/addToCart/"+widget.idd;
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"cartItem": "true"}';
  // make PATCH request
  http.Response response = await http.patch(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  String body = response.body;
  print(body);
  print(statusCode);
}
  getQuestions() async {
    http.Response response =
    await http.get('http://192.168.43.243:3000/MySHop/user/getProductById/'+widget.idd);
    data = json.decode(response.body);
    setState(() {
      categoryList = data['data']['price'];
       descriptions = data['data']['description'];
        title = data['data']['title'];
         id = data['data']['_id'];
         loading = false;
    });
    debugPrint(response.body);
  }
 @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => loadData());
  }

  loadData() {
    getQuestions();
    _makePatchRequest();
  }
  

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }



  String selected = "blue";
  bool favourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The whole application area
      
       body: loading ? new Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Colors.blue),
                  ),
                  ): categoryList.length != 0 ?
      SafeArea(
        child: Column(
          children: <Widget>[
            hero(),
            spaceVertical(20),
            //Center Items
            Expanded (
              child: sections(),
            ),

            //Bottom Button
            purchase()
          ],
        ),
      ):new Center(child: Text("No products"),)
    );
  }


  ///************** Hero   ***************************************************/
  Widget hero(){
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0,30,0,0),
            child: Container(child: Image.asset("assets/iphone11.png",height: 200,width: 300,)),
          ), //This
          // should be a paged
          // view.
          Positioned(child: appBar(),top: 2,),

          Positioned(child: FloatingActionButton(
              elevation: 2,
              child:Image.asset(favourite? "assets/heart_icon.png" : "assets/heart_icon_disabled.png",
                width: 30,
                height: 30,),
              backgroundColor: Colors.white,
              onPressed: (){
                setState(() {
                  favourite = !favourite;
                });
              }
          ),
            bottom: 5,
            right: 20,
          ),

        ],
      ),
    );
  }


  Widget appBar(){
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset("images/back_button.png"),
          Container(
            child: Column(
              children: <Widget>[

                Text(title.toString()??"", style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF2F2F3E)
                ),),
              ],
            ),
          ),
          Image.asset("images/bag_button.png", width: 27, height: 30,),
        ],
      ),
    );
  }

  Widget sections(){
    return Container(
      padding: EdgeInsets.all(16),

      child: Column(
        children: <Widget>[
          counter(),
          description(),
          spaceVertical(50),
        ],
      ),

    );
  }

  Widget counter(){
    return Container(
      child:new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text("Add Quantity"),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(40,0,0,0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 90,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(15.0)),
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2,
                        )),
                    child: Center(
                      child: new Text('$_n',
                          textAlign: TextAlign.center,
                          style: new TextStyle(fontSize: 20.0)),
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Colors.lightBlue[50], // button color
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(width: 45, height: 45, child: Icon(Icons.add)),
                      onTap: add,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.lightBlue[50], // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(width: 45, height: 45, child: Icon(Icons.remove)),
                        onTap: minus,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

      ),
    );
  }



  Widget description(){
    return Text(
      descriptions.toString()??"",


      textAlign: TextAlign.justify,
      style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),);
  }

  Widget purchase(){
    return Container(
      padding: EdgeInsets.fromLTRB(8,0,10,8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text("ADD TO Cart +",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F3E)
              ),
            ), color: Colors.transparent,
            onPressed: (){
              _makePatchRequest();
              Navigator.push(context, new MaterialPageRoute(builder: (context) => MyCart(idd: id,)));
            },),
          Text(r"₹"+categoryList??"",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w100,
                color: Color(0xFF2F2F3E)
            ),
          )
        ],
      ),
    );
  }

  /***** End */





  ///************** UTILITY WIDGET ********************************************/
  Widget spaceVertical(double size){
    return SizedBox(height: size,);
  }

  Widget spaceHorizontal(double size){
    return SizedBox(width: size,);
  }
/***** End */
}