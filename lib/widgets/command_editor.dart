import 'package:flutter/material.dart';
import '../models/command_action.dart';

class CommandEditor extends StatefulWidget {
  final CommandAction? initialData;
  final bool Function(CommandAction) onSubmit;

  const CommandEditor({
    super.key,
    this.initialData,
    required this.onSubmit,
  });

  @override
  State<CommandEditor> createState() => _CommandEditorState();
}

class _CommandEditorState extends State<CommandEditor> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _commandsController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialData?.description ?? '');
    _commandsController = TextEditingController(
      text: widget.initialData?.commands.join('\n') ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _commandsController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final desc = _descriptionController.text.trim();
    final commands = _commandsController.text
        .split('\n')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    if (name.isEmpty || commands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名称和命令不能为空')),
      );
      return;
    }

    if (widget.onSubmit(
      CommandAction(name: name, description: desc, commands: commands),
    )) {
      Navigator.of(context).pop(); // 关闭弹窗
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialData == null ? '新增命令' : '编辑命令'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '名称'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: '描述'),
              ),
              TextField(
                controller: _commandsController,
                decoration: const InputDecoration(labelText: '命令（每行一条）'),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                minLines: 4,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('保存'),
        ),
      ],
    );
  }
}
