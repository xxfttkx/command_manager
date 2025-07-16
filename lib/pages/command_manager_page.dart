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
          : ReorderableListView.builder(
              itemCount: commands.length,
              onReorder: (oldIndex, newIndex) {
                vm.reorder(oldIndex, newIndex);
              },
              proxyDecorator: (child, index, animation) => Material(
                child: child,
              ),
              itemBuilder: (context, index) {
                final action = commands[index];
                return KeyedSubtree(
                  // 或者 ListTile 直接设置 key 也可以
                  key: ValueKey(action.name), // 必须有 key，否则会报错或顺序错乱
                  child: CommandCard(
                    action: action,
                    onEdit: () => _openEditor(initial: action),
                    onDelete: () => vm.deleteCommand(action),
                    onRun: () => vm.runCommand(action),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        tooltip: '添加命令',
        child: const Icon(Icons.add),
      ),
    );
  }
}
