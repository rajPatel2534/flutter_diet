import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_demo/screens/home_page/home_page.dart';
import 'package:login_demo/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUI extends StatefulWidget {
  // @override
  // State<StatefulWidget> createState() {
  //   return null;
  // }

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginUI>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Color themeColor = ColorHelper.themeColor;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Login Demo"),
              backgroundColor: this.themeColor,
            ),
            backgroundColor: Colors.green[100],
            body: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  2.0, // has the effect of extending the shadow
                              offset: Offset(
                                1.0, // horizontal, move right 10
                                1.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        // color: Colors.blueAccent,
                        child: Column(children: <Widget>[
                          Theme(
                              data: ThemeData(primaryColor: this.themeColor),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Email',
                                  icon: Icon(Icons.email),
                                ),
                              )),
                          Theme(
                              data: ThemeData(primaryColor: this.themeColor),
                              child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Password',
                                    icon: Icon(Icons.vpn_key),
                                  ))),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: RaisedButton(
                                color: this.themeColor,
                                textColor: Colors.white,
                                child: Text("Sign In"),
                                onPressed: () {
                                  checkLoginCredentials(emailController.text,
                                      passwordController.text, context);
                                },
                              )),
                          RaisedButton(
                            padding: EdgeInsets.all(0.0),
                            color: this.themeColor,
                            textColor: Colors.white,
                            child: Text("Sign Up"),
                            onPressed: () {
                              debugPrint('Sign up clicked');
                            },
                          )
                        ])),
                  ]),
            )));
  }

  void checkLoginCredentials(
      String email, String password, BuildContext context) {
    if (email == "raj" && password == "raj") {
      saveLoginDetails();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          ModalRoute.withName("/home"));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Invalid Username Or Password !!!"),
            );
          });
    }
  }

  saveLoginDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('Pressed  times.');
    await preferences.setBool('isLoggedIn', true);
  }

  void checkLogIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool counter = (prefs.getBool('isLoggedIn') ?? false);
    if (counter == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }
}
