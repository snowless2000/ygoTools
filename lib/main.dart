import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_background_tool/route/route_path.dart';
import 'package:my_background_tool/utils/tool_utils.dart';
import 'data_class/const.dart';
import 'data_class/setting_class.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ygo壁纸替换工具'),
      routes: routePath,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String path = '';
  String hint = '你还没有选择ygo路径';
  bool inited = false;

  String imagePath = '';

  int ygoVersion = 1;

  @override
  Widget build(BuildContext context) {
    if(!inited){
      initFromSettings();
      inited = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Text(
                  hint,
                  style: const TextStyle(
                      fontSize: 20
                  ),),
                const SizedBox(width: 30),
                ElevatedButton(onPressed: intentToChooseFile, child: const Text("选择YGO目录")),
                const SizedBox(width: 10,),

              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("请选择ygo版本:   ",
                    style: const TextStyle(
                        fontSize: 20
                    )),
                DropdownButton(items: const [
                  DropdownMenuItem(child: Text("YGO pro 1"),value: 1,),
                  DropdownMenuItem(child: Text("YGO pro 2"),value: 2,)
                ], onChanged: dropdownChanged, value: ygoVersion,),
                const SizedBox(width: 10,),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: intentToChooseBackground, child: Text("修改背景")),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: intentToCardChange, child: Text("修改卡图")),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void intentToChooseFile() async{
    var result = await Navigator.pushNamed(context, pathChoosePage);
    if(result != null) {
      print("result = $result");
      setState(() {
        path = result as String;
        hint = "你的ygo路径已选择： $path";
      });
    }
  }

  void intentToChooseBackground() {
    print('intent');
    Navigator.pushNamed(context, chooseBackground);
  }

  void initFromSettings(){
    try {
      File f = File(ConstUtils.SETTINGS_PATH);
      if(f.existsSync()) {
        String str = f.readAsStringSync();
        Map settingMap = const JsonDecoder().convert(str);
        ToolUtils.globalSetting = Settings.fromJson(settingMap);
        path = ToolUtils.globalSetting.filePath;
        ygoVersion = ToolUtils.globalSetting.ygoVersion;
        if(path.isNotEmpty) {
          hint = "你的ygo路径已选择： $path";
        }
      }
    } catch(e) {
      print(e);
    }
  }

  void dropdownChanged(value) {
      setState(() {
        ygoVersion = value;
      });

      String filePath = ConstUtils.SETTINGS_PATH;
      try {
        File file = File(filePath);
        ToolUtils.globalSetting.ygoVersion = ygoVersion;
        String str = const JsonEncoder().convert(ToolUtils.globalSetting);
        file.writeAsString(str);
      } catch(e) {
        print(e);
      }
  }


  void intentToCardChange() {
    Navigator.pushNamed(context, cardChange);
  }
}
