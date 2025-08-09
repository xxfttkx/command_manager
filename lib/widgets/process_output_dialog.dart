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
  String get _cleanedText =>
      widget.lines.where((line) => line.isNotEmpty).join('\n');

  bool useViewModel = false;

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.6;
    final maxWidth = mediaQuery.size.width * 0.6;
    final title = widget.title;

    var lines = widget.lines;
    if (useViewModel) {
      final vm = context.watch<CommandManagerViewModel>();
      final rc = vm.getRunningCommandByPid(widget.pid);
      if (rc != null) {
        lines = List.of(rc.lines);
      }
    }
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
