import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/command_action.dart';
import '../services/config_storage.dart';

class CommandManagerViewModel extends ChangeNotifier {
  List<CommandAction> _commands = [];

  List<CommandAction> get commands => List.unmodifiable(_commands);

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

  Future<void> runCommand(CommandAction action) async {
    try {
      final fullCommand = action.commands.join(' ; ');
      final result = await Process.run(
        'powershell.exe',
        ['-Command', fullCommand],
      );
      debugPrint('[${action.name}] → ${result.stdout}');
      if (result.stderr != null && result.stderr.toString().trim().isNotEmpty) {
        debugPrint('stderr: ${result.stderr}');
      }
    } catch (e) {
      debugPrint('Error running command: $e');
    }
  }
}
