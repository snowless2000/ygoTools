
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_background_tool/data_class/const.dart';
import 'package:my_background_tool/data_class/setting_class.dart';

class ToolUtils {
  static Settings globalSetting = Settings();

  static String getExeDirectory() {
    // print("systemDirectory: ${Platform.resolvedExecutable}");
    List<String> pathList = Platform.resolvedExecutable.split('\\');
    String resPath = "";
    for(int i = 0; i < pathList.length - 1; i++) {
    resPath += pathList.elementAt(i) + '\\';
    }
    // print(resPath);
    return resPath;
  }

  static String getYGOPath() {
    return globalSetting.filePath;
  }

  static int getYGOVersion() {
    return globalSetting.ygoVersion;
  }

  static bool copyOriginalFileToBackup(String originalCardPath) {
    try {
      File origin = File(originalCardPath);
      Directory d = Directory(ConstUtils.BACKUP_DIRECTORY);
      if(!d.existsSync()) {
        d.createSync();
      }
      String fileName = originalCardPath.split(Platform.pathSeparator).last;
      print("fileName = $fileName");
      if(File("${d.path}${Platform.pathSeparator}$fileName").existsSync()) {
        return true;
      }
      origin.copySync("${d.path}${Platform.pathSeparator}$fileName");
      print(d.path);
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  static int copyBackupFileToOriginal() {
    print("-------backup------");
    print("ygoVersion = ${getYGOVersion()}");
    String dstDirectoryPath = getYGOVersion() == 2? "${getYGOPath()}${Platform.pathSeparator}picture${Platform.pathSeparator}card" : "${getYGOPath()}${Platform.pathSeparator}pics";
    print("dstDirectory = $dstDirectoryPath");
    try {
      Directory backupDirectory = Directory(ConstUtils.BACKUP_DIRECTORY);
      if(!backupDirectory.existsSync()) {
        return -1; //备份目录不存在，没有已备份的文件
      }

      Directory dst = Directory(dstDirectoryPath);
      if(!dst.existsSync()) {
        return -2; //目标路径错误
      }

      List<FileSystemEntity> fileList = backupDirectory.listSync();
      for(int i = 0; i < fileList.length; i++) {
        String backupFilePath = fileList.elementAt(i).path;
        String fileName = backupFilePath.split(Platform.pathSeparator).last;
        print("dst: $dstDirectoryPath");
        File backupFile = File(backupFilePath);
        backupFile.copySync("${dst.path}${Platform.pathSeparator}$fileName");
        print("copy $backupFilePath to ${dst.path}$fileName");
        backupFile.deleteSync();
      }
      return 0;
    } catch(e) {
      print(e);
      return -3;
    }
  }

  static showCommonDialog(BuildContext context, String hint) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("提示"),
        content: Text(hint),
        actions: <Widget>[
          TextButton(
            child: const Text("确定"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    });
  }
}