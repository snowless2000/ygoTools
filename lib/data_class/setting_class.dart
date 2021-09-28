class Settings {
  Settings({this.filePath = "", this.ygoVersion = 1});
  String filePath;
  int ygoVersion;
  Settings.fromJson(Map<dynamic, dynamic> json)
      : filePath = json['filePath'],
        ygoVersion = json['ygoVersion'];

  Map<dynamic, dynamic> toJson() =>
      {
        "filePath": filePath,
        "ygoVersion":ygoVersion
      };
}