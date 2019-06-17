import 'package:flutter/material.dart';
import 'package:login_demo/screens/home_page/home_page.dart';
import 'package:login_demo/screens/login_screen/login_ui.dart';
import 'package:login_demo/utils/color.dart';
import 'package:login_demo/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

Future<void> main() async {
  ColorHelper colorHelper =new  ColorHelper();

  // colorHelper.saveColorIntoSharedPreferences(Colors.green);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  //  int colorCode =   prefs.getInt('themeColor');
  //  debugPrint('${colorCode}');
  //  debugPrint('${Colors.green}');
  //  if(colorCode == null){
  //    colorHelper.themeColor =  Colors.green;
  //  }
  //  colorHelper.themeColor = ((colorCode == null)? Colors.green: Color(colorCode) );
  bool isLoggedIn = prefs.getBool('isLoggedIn');

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
        runApp(MaterialApp(
    title: 'Diet_Fit',
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
      routes: {
        '/login' : (context) => LoginUI(),
        '/home' : (context) => HomePage()

      },
    theme: ThemeData(
      primarySwatch: Colors.blue
    ),
    home: isLoggedIn == true ? HomePage() : LoginUI()
    ));});
}