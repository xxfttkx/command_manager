import 'dart:convert';
import 'dart:io';
import 'package:command_manager/models/running_command.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/command_action.dart';
import '../services/config_storage.dart';

enum AddCommandResult {
  success,
  duplicate,
}

class CommandManagerViewModel extends ChangeNotifier {
  List<CommandAction> _commands = [];

  List<CommandAction> get commands => List.unmodifiable(_commands);

  String _filter = '';
  String get filter => _filter;

  final List<RunningCommand> _running = [];

  List<RunningCommand> get runningCommands => List.unmodifiable(_running);

  List<RunningCommand> _finishedCommands = [];

  List<RunningCommand> get finishedCommands =>
      List.unmodifiable(_finishedCommands);

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

  AddCommandResult addOrUpdateCommand(CommandAction updated,
      {CommandAction? original}) {
    if (original != null) {
      return updateCommand(updated, original);
    } else {
      return addCommand(updated);
    }
  }

  AddCommandResult addCommand(CommandAction newCommand) {
    final exists = _commands.any((cmd) => cmd.name == newCommand.name);
    if (exists) {
      return AddCommandResult.duplicate;
    }

    _commands.add(newCommand);
    ConfigStorage.saveCommands(_commands);
    notifyListeners();
    return AddCommandResult.success;
  }

  AddCommandResult updateCommand(
      CommandAction updated, CommandAction original) {
    final index = _commands.indexOf(original);
    if (index == -1) {
      throw Exception('Original command not found.');
    }

    if (updated.name != original.name) {
      final nameExists = _commands.any((cmd) => cmd.name == updated.name);
      if (nameExists) {
        return AddCommandResult.duplicate;
      }
    }
    _commands[index] = updated;
    ConfigStorage.saveCommands(_commands);
    notifyListeners();
    return AddCommandResult.success;
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

  Future<void> runCommandByName(String name) async {
    final action = _commands.firstWhere(
      (cmd) => cmd.name == name,
      orElse: () => throw Exception('Command not found: $name'),
    );
    await runCommand(action);
  }

  Future<void> runCommand(CommandAction action) async {
    final prefs = await SharedPreferences.getInstance();
    final shellPath = prefs.getString('shellPath') ?? 'powershell.exe';
    final argsTemplate = prefs.getString('argsTemplate') ?? '-Command';
    try {
      final fullCommand = action.commands.join(' ; ');
      final process = await Process.start(
        shellPath,
        [argsTemplate, fullCommand],
      );

      final rc = RunningCommand(
        pid: process.pid,
        name: action.name,
        process: process,
        startTime: DateTime.now(),
      );
      _running.add(rc);
      notifyListeners();

      final stdoutSub = process.stdout.transform(utf8.decoder).listen((line) {
        rc.output.write(line);
        notifyListeners();
      });

      final stderrSub = process.stderr.transform(utf8.decoder).listen((line) {
        rc.output.write('[stderr] $line');
        notifyListeners();
      });

      await process.exitCode.then((exitCode) {
        stdoutSub.cancel();
        stderrSub.cancel();
        debugPrint('Process exited with code $exitCode');
      });

      _finishedCommands.add(rc);
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
