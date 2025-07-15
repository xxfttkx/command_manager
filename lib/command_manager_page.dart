import 'package:flutter/material.dart';
import 'models/command_action.dart';
import 'widgets/command_card.dart';
import 'widgets/command_editor.dart';
import 'services/config_storage.dart';
import 'dart:io';

class CommandManagerPage extends StatefulWidget {
  const CommandManagerPage({super.key});

  @override
  State<CommandManagerPage> createState() => _CommandManagerPageState();
}

class _CommandManagerPageState extends State<CommandManagerPage> {
  List<CommandAction> _commands = [];

  @override
  void initState() {
    super.initState();
    _loadCommands();
  }

  Future<void> _loadCommands() async {
    final list = await ConfigStorage.loadCommands();
    setState(() {
      _commands = list;
    });
  }

  void _openEditor({CommandAction? initial}) {
    showDialog(
      context: context,
      builder: (_) => CommandEditor(
        initialData: initial,
        onSubmit: (updated) {
          setState(() {
            if (initial != null) {
              final index = _commands.indexOf(initial);
              _commands[index] = updated;
            } else {
              _commands.add(updated);
            }
          });
          ConfigStorage.saveCommands(_commands);
        },
      ),
    );
  }

  void _deleteCommand(CommandAction action) {
    setState(() {
      _commands.remove(action);
    });
    ConfigStorage.saveCommands(_commands);
  }

  Future<void> _runCommand(CommandAction action) async {
    for (var cmd in action.commands) {
      try {
        final result = await Process.run(
          Platform.isWindows ? 'cmd.exe' : 'bash',
          Platform.isWindows ? ['/c', cmd] : ['-c', cmd],
        );
        debugPrint('[${action.name}] $cmd -> ${result.stdout}');
      } catch (e) {
        debugPrint('Error running $cmd: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('命令映射管理器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新加载配置',
            onPressed: _loadCommands,
          ),
        ],
      ),
      body: _commands.isEmpty
          ? const Center(child: Text('暂无命令，点击 + 添加'))
          : ListView.builder(
              itemCount: _commands.length,
              itemBuilder: (context, index) {
                final action = _commands[index];
                return CommandCard(
                  action: action,
                  onEdit: () => _openEditor(initial: action),
                  onDelete: () => _deleteCommand(action),
                  onRun: () => _runCommand(action),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
        tooltip: '添加命令',
      ),
    );
  }
}
