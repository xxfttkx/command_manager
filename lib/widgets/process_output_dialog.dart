import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/models/running_command.dart';
import 'package:command_manager/utils.dart' as utils;
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/viewmodels/settings_viewmodel.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProcessOutputDialog extends StatefulWidget {
  final int pid;
  final ExecutionType type;
  ProcessOutputDialog({
    super.key,
    required this.pid,
    required this.type,
  });

  @override
  State<ProcessOutputDialog> createState() => _ProcessOutputDialogState();
}

class _ProcessOutputDialogState extends State<ProcessOutputDialog> {
  String get _cleanedText =>
      rc?.lines.where((line) => line.isNotEmpty).join('\n') ?? '';
  bool isLiveOutput = false;
  final controller = ScrollController();
  int rowNum = 0;
  late RunningCommand? rc;
  @override
  void initState() {
    final settingsViewModel = context.read<SettingsViewModel>();
    isLiveOutput = settingsViewModel.defaultLiveOutputEnabled;
    final vm = context.read<CommandManagerViewModel>();
    rc = vm.getRunningCommandByPidAndType(widget.pid, widget.type);
    rowNum = rc?.lines.length ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose(); // ✅ 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.6;
    final maxWidth = mediaQuery.size.width * 0.6;
    final vm = context.watch<CommandManagerViewModel>();
    final title = rc?.name ?? '';
    if (isLiveOutput) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients) {
          controller.jumpTo(controller.position.maxScrollExtent);
        }
      });
      rc = vm.getRunningCommandByPidAndType(widget.pid, widget.type);
      // 如果是实时模式，行数不限制
      rowNum = rc?.lines.length ?? 0;
    }
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
          widget.type == ExecutionType.running
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.logRealtimeOutput),
                    Switch(
                      value: isLiveOutput,
                      onChanged: (value) {
                        if (!value) {
                          rowNum = rc?.lines.length ?? 0; // 切换到非实时模式时，重置行数
                        }
                        setState(() => isLiveOutput = value);
                      },
                    ),
                  ],
                )
              : const SizedBox.shrink(),
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
            itemCount: rowNum,
            // addAutomaticKeepAlives: false,
            // addRepaintBoundaries: false, // 也可以设为 false 避免 GPU 分片
            // itemExtent: 30, // 如果每项高度固定，建议加这个，极大提升性能
            prototypeItem: const Text(
              'Sample line for prototype',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            itemBuilder: (context, index) {
              final line = rc?.lines[index] ?? '';
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
