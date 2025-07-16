import 'dart:convert';
import 'dart:io';
import 'package:command_manager/models/running_command.dart';
import 'package:flutter/foundation.dart';
import '../models/command_action.dart';
import '../services/config_storage.dart';

class CommandManagerViewModel extends ChangeNotifier {
  List<CommandAction> _commands = [];

  List<CommandAction> get commands => List.unmodifiable(_commands);

  String _filter = '';
  String get filter => _filter;

  final List<RunningCommand> _running = [];

  List<RunningCommand> get runningCommands => List.unmodifiable(_running);

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  List<CommandAction> get filteredCommands {
    if (_filter.isEmpty) return _commands;
    return _commands.where((c) {
      return c.name.contains(_filter) ||
          c.commands.any((cmd) => cmd.contains(_filter));
    }).toList();
  }

  Future<void> loadCommands() async {
    final list = await ConfigStorage.loadCommands();
    _commands = list;
    notifyListeners();
  }

  void addOrUpdateCommand(CommandAction updated, {CommandAction? original}) {
    if (original != null) {
      final index = _commands.indexOf(original);
      if (index != -1) {
        _commands[index] = updated;
      }
    } else {
      _commands.add(updated);
    }
    ConfigStorage.saveCommands(_commands);
    notifyListeners();
  }

  void deleteCommand(CommandAction action) {
    _commands.remove(action);
    ConfigStorage.saveCommands(_commands);
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--; // ReorderableListView 的特殊行为

    final item = _commands.removeAt(oldIndex);
    _commands.insert(newIndex, item);

    ConfigStorage.saveCommands(_commands);
    notifyListeners();
  }

  Future<void> runCommand(CommandAction action) async {
    try {
      final fullCommand = action.commands.join(' ; ');
      final process = await Process.start(
        'powershell.exe',
        ['-Command', fullCommand],
      );

      final rc = RunningCommand(
        pid: process.pid,
        name: action.name,
        process: process,
        startTime: DateTime.now(),
      );
      _running.add(rc);
      notifyListeners();

      process.stdout.transform(utf8.decoder).listen((line) {
        rc.output.write(line);
        notifyListeners();
      });

      process.stderr.transform(utf8.decoder).listen((line) {
        rc.output.write('[stderr] $line');
        notifyListeners();
      });

      await process.exitCode;
      _running.removeWhere((p) => p.pid == process.pid);
      notifyListeners();
    } catch (e) {
      debugPrint('Error running command: $e');
    }
  }

  void killProcess(int pid) async {
    final target = _running.firstWhere(
      (p) => p.pid == pid,
      orElse: () => throw Exception('Process not found'),
    );

    // 用 taskkill 杀整个进程树（包括 powershell 启动的子进程）
    await Process.run(
      'taskkill',
      ['/PID', '$pid', '/T', '/F'],
    );

    // 从追踪列表中移除
    _running.remove(target);
    notifyListeners();
  }
}
