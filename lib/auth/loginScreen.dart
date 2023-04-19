import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../consts/string_const.dart';
import '../consts/style_const.dart';
import '../ui/homePage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late LoginReturnModel userLogin;

  var username, password;
  bool obsecureTextState = true;
  IconData showPasswordIcon = Icons.remove_red_eye;
  final _loginFormKey = GlobalKey<FormState>();

  var checkedValue = false;
  late http.Response response;

  @override
  void initState() {
    // TODO: implement initState
    // progressDialog = loadProgressBar(context);
    // loadBranches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: kMarginPaddMedium,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    // Image.asset("assets/images/soorilogo.png",height: 100,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 20,color: Colors.black),
                        ),
                        Text(
                          StringConst.name,
                          style: TextStyle(fontSize: 20,color: Color(0xffBF1E2E)),
                        ),

                        // Text(
                        //   StringConst.account,
                        //   style: TextStyle(fontSize: 20,color: Colors.black),
                        // ),
                      ],
                    ),
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightVeryBig,
                    kHeightMedium,


                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [


                          kHeightVeryBigForForm,
                          kHeightVeryBigForForm,
                          kHeightVeryBigForForm,
                          kHeightVeryBigForForm,

                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Name';
                              }
                            },
                            cursorColor: Color(0xff3667d4),
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              username = value;
                            },
                            style: TextStyle(color: Colors.grey),
                            decoration: kFormFieldDecoration.copyWith(

                              hintText: 'Username',
                              prefixIcon: const Icon(
                                Icons.person_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          kHeightVeryBigForForm,
                          kHeightVeryBigForForm,
                          kHeightVeryBigForForm,

                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                            },
                            style: TextStyle(color: Colors.grey),
                            obscureText: obsecureTextState,
                            cursorColor: Color(0xff3667d4),
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: kFormFieldDecoration.copyWith(
                                hintText: 'Password',
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (obsecureTextState != false) {
                                        obsecureTextState = true;
                                        showPasswordIcon = Icons.remove_red_eye;
                                      } else {
                                        obsecureTextState = true;
                                        showPasswordIcon =
                                            Icons.remove_red_eye_outlined;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    showPasswordIcon,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    // kHeightSmall,

                    // Container(
                    //   color: Colors.transparent,
                    //   child: CheckboxListTile(
                    //     title: Text(
                    //       StringConst.rememberMe,
                    //       style: kTextStyleWhite.copyWith(fontSize: 16.0,color: Colors.black),
                    //     ),
                    //     value: checkedValue,
                    //     onChanged: (newValue) {
                    //       setState(() {
                    //         checkedValue = newValue!;
                    //       });
                    //     },
                    //     controlAffinity: ListTileControlAffinity
                    //         .leading, //  <-- leading Checkbox
                    //   ),
                    // ),
                    kHeightMedium,
                    kHeightMedium,
                    kHeightMedium,
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff424143),
                        ),

                        onPressed: ()=>{
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                          login()
                        },
                        child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),)
                    ),
                    kHeightMedium,
                    kHeightVeryBigForForm,


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future login() async {


    var response = await http.post(
      Uri.parse(StringConst.mainUrl+StringConst.login),
      body: ({
        'user_name': username,
        'password': password,
      }),
    );
    log(StringConst.mainUrl+StringConst.login);
    log(username+password);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("access_token",
          json.decode(response.body)['tokens']['access'] ?? '#');
      sharedPreferences.setString("refresh_token",
          json.decode(response.body)['tokens']['refresh'] ?? '#');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

    } else {
      // log(response.body);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      // Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }


}