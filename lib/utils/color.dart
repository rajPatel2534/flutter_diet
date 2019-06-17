
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorHelper{
    // static ColorHelper _colorHelper;

    static Color themeColor= Colors.green;

    ColorHelper(){
      // saveColorIntoSharedPreferences(themeColor);
      debugPrint('called');
      staticsetInitialColorValues();
    }

    // ColorHelper._createInstance();
  // factory ColorHelper(){
  //   //For singleton obj
  //   if(_colorHelper == null){
  //   _colorHelper = ColorHelper._createInstance();
  //   }
  //   return _colorHelper;
  // }

  // Color get themeColor => _themeColor;
  // set themeColor(Color newColor){
  //    this.themeColor = newColor;
  //   // this.saveColorIntoSharedPreferences(this.themeColor);
  // }

  saveColorIntoSharedPreferences(Color newColor) async{
    debugPrint('${themeColor.value}');
    themeColor = newColor;
        SharedPreferences preferences = await SharedPreferences.getInstance();
    print('Pressed  times.');
    await preferences.setInt('themeColor', themeColor.value);


  }

staticsetInitialColorValues() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int themeColorCode = preferences.getInt('themeColor');
  debugPrint('$themeColorCode');
  if(themeColorCode == null) themeColor = Colors.green;
  else themeColor = Color(themeColorCode);
}
}