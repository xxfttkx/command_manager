import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/utils.dart' as utils;
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProcessOutputDialog extends StatefulWidget {
  final String title;
  final List<String> lines;
  final int pid;
  ProcessOutputDialog({
    super.key,
    required this.title,
    required this.lines,
    required this.pid,
  });

  @override
  State<ProcessOutputDialog> createState() => _ProcessOutputDialogState();
}

class _ProcessOutputDialogState extends State<ProcessOutputDialog> {
  String get _cleanedText => lines.where((line) => line.isNotEmpty).join('\n');

  bool useViewModel = false;
  List<String> lines = [];
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();

    // 等一帧，让 ListView 渲染完成后再滚动
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (controller.hasClients) {
    //     controller.jumpTo(controller.position.maxScrollExtent);
    //     // 如果想要平滑滚动，可以用：
    //     // controller.animateTo(
    //     //   controller.position.maxScrollExtent,
    //     //   duration: const Duration(milliseconds: 300),
    //     //   curve: Curves.easeOut,
    //     // );
    //   }
    // });
  }

  @override
  void dispose() {
    controller.dispose(); // ✅ 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.jumpTo(controller.position.maxScrollExtent);
      }
    });
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.6;
    final maxWidth = mediaQuery.size.width * 0.6;
    final title = widget.title;
    final vm = context.watch<CommandManagerViewModel>();
    lines = useViewModel
        ? (vm.getRunningCommandByPid(widget.pid)?.lines ?? [])
        : widget.lines;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.logRealtimeOutput),
              Switch(
                value: useViewModel,
                onChanged: (value) {
                  setState(() => useViewModel = value);
                },
              ),
            ],
          ),
          SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy',
            onPressed: () {
              utils.copyToClipboard(_cleanedText);
              AppSnackbar.show(context, 'Copied to clipboard');
            },
          ),
        ],
      ),
      content: SizedBox(
        height: maxHeight,
        width: maxWidth,
        child: Scrollbar(
          controller: controller,
          child: ListView.builder(
            controller: controller,
            physics: const ClampingScrollPhysics(),
            itemCount: lines.length,
            // addAutomaticKeepAlives: false,
            // addRepaintBoundaries: false, // 也可以设为 false 避免 GPU 分片
            // itemExtent: 30, // 如果每项高度固定，建议加这个，极大提升性能
            prototypeItem: const Text(
              'Sample line for prototype',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            itemBuilder: (context, index) {
              final line = lines[index];
              return Text(
                line,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
