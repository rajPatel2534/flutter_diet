import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_demo/screens/settings/theme_color_setting/theme_color_setting.dart';
import 'package:login_demo/utils/color.dart';

class SettingHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingHomeState();
  }
}

class _SettingHomeState extends State<SettingHome> {
  List<String> settingsList = ['Change Theme Color'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getSettingListView(),
    );
  }

  ListView getSettingListView() {
    return ListView.builder(
        itemCount: this.settingsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 3.0,
           child :  ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: Text(this.settingsList[index]),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              navigateToTappedSettingScreen(index);
            },
          ));
        });
  }

  navigateToTappedSettingScreen(int index) {
    if(index == 0){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ThemeColorSetting();
      }));
    }
  }

}
