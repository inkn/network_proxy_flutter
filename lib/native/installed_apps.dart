import 'package:flutter/services.dart';

class InstalledApps {
  static const MethodChannel _methodChannel = MethodChannel('com.proxy/installedApps');

  static Future<List<AppInfo>> getInstalledApps(bool withIcon, {String? packageNamePrefix}) {
    return _methodChannel
        .invokeListMethod<Map>('getInstalledApps', {"withIcon": withIcon, "packageNamePrefix": packageNamePrefix}).then(
            (value) => value?.map((e) => AppInfo.formJson(e)).toList() ?? []);
  }

  static Future<AppInfo> getAppInfo(String packageName) async {
    return _methodChannel
        .invokeMethod<Map>('getAppInfo', {"packageName": packageName}).then((value) => AppInfo.formJson(value!));
  }
}

class AppInfo {
  String? name;
  String? packageName;
  String? versionName;
  int? versionCode;

  //icon
  Uint8List? icon;

  AppInfo({
    this.name,
    this.packageName,
    this.versionName,
    this.versionCode,
    this.icon,
  });

  AppInfo.formJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    packageName = json['packageName'];
    versionName = json['versionName'];
    versionCode = json['versionCode'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['packageName'] = packageName;
    data['versionName'] = versionName;
    data['versionCode'] = versionCode;
    data['icon'] = icon;
    return data;
  }
  @override
  String toString() {
    return toJson().toString();
  }
}
