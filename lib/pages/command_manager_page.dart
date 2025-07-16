import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/command_action.dart';
import '../widgets/command_card.dart';
import '../widgets/command_editor.dart';
import '../viewmodels/command_manager_viewmodel.dart';

class CommandManagerPage extends StatefulWidget {
  const CommandManagerPage({super.key});

  @override
  State<CommandManagerPage> createState() => _CommandManagerPageState();
}

class _CommandManagerPageState extends State<CommandManagerPage> {
  @override
  void initState() {
    super.initState();
    // 初次加载配置
    Future.microtask(() {
      context.read<CommandManagerViewModel>().loadCommands();
    });
  }

  void _openEditor({CommandAction? initial}) {
    showDialog(
      context: context,
      builder: (_) => CommandEditor(
        initialData: initial,
        onSubmit: (updated) {
          final vm = context.read<CommandManagerViewModel>();
          vm.addOrUpdateCommand(updated, original: initial);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CommandManagerViewModel>();
    final commands = vm.commands;

    return Scaffold(
      appBar: AppBar(
        title: const Text('命令映射管理器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新加载配置',
            onPressed: () => vm.loadCommands(),
          ),
        ],
      ),
      body: commands.isEmpty
          ? const Center(child: Text('暂无命令，点击 + 添加'))
          : ListView.builder(
              itemCount: commands.length,
              itemBuilder: (context, index) {
                final action = commands[index];
                return CommandCard(
                  action: action,
                  onEdit: () => _openEditor(initial: action),
                  onDelete: () => vm.deleteCommand(action),
                  onRun: () => vm.runCommand(action),
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
