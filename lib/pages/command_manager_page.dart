import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
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
          final result = vm.addOrUpdateCommand(updated, original: initial);
          switch (result) {
            case AddCommandResult.success:
              AppSnackbar.show(
                context,
                'Command "${updated.name}" saved successfully.',
              );
              break;
            case AddCommandResult.duplicate:
              AppSnackbar.showError(context,
                  'Another command with name "${updated.name}" already exists.');
              break;
            default:
              break;
          }
          return result == AddCommandResult.success;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CommandManagerViewModel>();
    final commands = vm.filteredCommands;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('命令映射管理器'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       tooltip: '重新加载配置',
      //       onPressed: () => vm.loadCommands(),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchCommand,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: vm.setFilter,
            ),
          ),
          Expanded(
            child: commands.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!.noMatchedCommand))
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
                        key: ValueKey(action.name),
                        child: CommandCard(
                          action: action,
                          onEdit: () => _openEditor(initial: action),
                          onDelete: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('确认删除'),
                                content: const Text('你确定要删除这个命令吗？此操作无法撤销。'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text('删除',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true && context.mounted) {
                              vm.deleteCommand(action); // 执行删除操作

                              // 弹出删除成功的提示
                              AppSnackbar.show(
                                context,
                                '命令 "${action.name}" 已成功删除。',
                              );
                            }
                          },
                          onRun: () => vm.runCommand(action),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        tooltip: '添加命令',
        child: const Icon(Icons.add),
      ),
    );
  }
}
