import 'package:flutter/material.dart';
import 'package:login_demo/utils/color.dart';

class ThemeColorSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ThemeColorSettingState();
  }
}

class _ThemeColorSettingState extends State<ThemeColorSetting> {
  Color themeColor = ColorHelper.themeColor;
  List<Color> colors = List<Color>();
  ColorHelper colorHelper = ColorHelper();
  int count = 0;
  int selectedIndex ;
  _ThemeColorSettingState(){
    setSelectedColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Theme Color'),
        backgroundColor: this.themeColor,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: getListOfColors(),
      ),
    );
  }

  GridView getListOfColors() {
    colors = [
      Colors.green,
      Colors.black,
      Colors.blue,
      Colors.blueAccent,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.grey,
      Colors.indigo,
      Colors.tealAccent,
      Colors.yellow,
      Colors.orange
    ];
    count = this.colors.length;

    return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        children: getGridViewChildrens());
  }

  List<Widget> getGridViewChildrens() {
    List<Widget> listOfColors = List<Widget>();
    for (int i = 0; i < this.count; i++) {
      listOfColors.add(GestureDetector(
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: (this.selectedIndex == i) ?  Colors.blueGrey[100] : Colors.white
            ),
          child: Container(
            width: 30.0,
            height: 30.0,
            color: this.colors[i],
          ),
        ),
        onTap: () {
          saveNewThemeColor(i);
        },
      ));
    }

    return listOfColors;
  }

  saveNewThemeColor(int position) {
    setState(() {
      colorHelper.saveColorIntoSharedPreferences(this.colors[position]);
      this.themeColor = this.colors[position];
      this.selectedIndex = position;
    });
  }

  setSelectedColor(){
    int index = this.colors.indexWhere((color) => color == this.themeColor);
    if(index != -1){
      this.selectedIndex = index;
    }
    else this.selectedIndex = 0;
  }
}
