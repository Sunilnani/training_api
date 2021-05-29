import 'package:flutter/material.dart';
import 'package:flutter_networkcalls/homepage.dart';
import 'package:flutter_networkcalls/network_calls/base_response.dart';
import 'package:flutter_networkcalls/network_calls/login_authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool hidepassword=false;
  bool _loading = false;
  Future<void> _performLogin() async {
    String mobile = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (mobile.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid number");
      return;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid password");
      return;
    }
    setState(() {
      _loading = true;
    });
    // Map<String, dynamic> postData = {
    //   "username": username,
    //   "password": password,
    // };
    Map<String,dynamic> data = {
      "email": mobile,
      "password": password,
    };
    ResponseData responseData = await loginManager.createLoginToken(data);
    setState(() {
      _loading = false;
    });
    if (responseData.status == ResponseStatus.SUCCESS) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(
          ),
        ),
      );
      // Navigate forward
    } else {
      Fluttertoast.showToast(msg: "invalid otp and password");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 120,),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign In",style: TextStyle(color: Color(0xFF2E3748),fontSize: 35,fontWeight: FontWeight.w700),)),
                SizedBox(height: 20,),
                Container(
                  height: 48,
                  child: TextField(
                    controller:_usernameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0x01FF8701)),borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Color(0xFFFF8701),width: 2)
                        ),
                        labelText: 'Number',
                        labelStyle: TextStyle(color: Color(0xFFFF8701)),
                        hintText: '+91'),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  height: 48,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: hidepassword,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Color(0xFFFF8701),width: 2)
                        ),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                hidepassword= !hidepassword;
                              });
                            },
                            icon:Icon(hidepassword?Icons.visibility_off:Icons.visibility)
                        ),
                        labelText: 'password',
                        labelStyle: TextStyle(color: Color(0xFFFF8701)),
                        hintText: 'password'),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot password?",style: TextStyle(color: Color(0xFF9FA5BB),fontSize: 12),)),
                SizedBox(
                  height: 30,
                ),
                if (_loading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3B83FC33),
                          offset: const Offset(
                            0.0,
                            5.0,
                          ),
                          blurRadius: 8.0,
                        ), //BoxShadow
                      ],
                      color: Color(0xFFFF8701), borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        _performLogin();
                        Fluttertoast.showToast(msg: "good and password");

                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),

                  ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?",style: TextStyle(color: Color(0xFF9FA5BB),fontSize: 15),),
                    FlatButton(
                      onPressed: (){
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) =>SignUp()));
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFFFF8701), fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
