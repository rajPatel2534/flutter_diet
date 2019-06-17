
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorHelper{
    static Color themeColor= Colors.green;

    ColorHelper(){
      staticsetInitialColorValues();
    }

  saveColorIntoSharedPreferences(Color newColor) async{
    themeColor = newColor;
        SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('themeColor', themeColor.value);
  }

staticsetInitialColorValues() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int themeColorCode = preferences.getInt('themeColor');
  if(themeColorCode == null) themeColor = Colors.green;
  else themeColor = Color(themeColorCode);
}
}