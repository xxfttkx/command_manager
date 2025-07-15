import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/command_action.dart';

class ConfigStorage {
  static const _fileName = 'command_config.json';

  /// 获取配置文件完整路径
  static Future<File> _getConfigFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$_fileName';
    return File(path);
  }

  /// 保存命令配置到本地文件
  static Future<void> saveCommands(List<CommandAction> commands) async {
    final file = await _getConfigFile();
    final jsonList = commands.map((c) => c.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await file.writeAsString(jsonString);
  }

  /// 从本地加载命令配置
  static Future<List<CommandAction>> loadCommands() async {
    final file = await _getConfigFile();

    if (!(await file.exists())) {
      return []; // 没有文件，返回空列表
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((json) => CommandAction.fromJson(json)).toList();
  }

  /// 可选：删除配置文件
  static Future<void> deleteConfig() async {
    final file = await _getConfigFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
