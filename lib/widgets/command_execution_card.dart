import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/models/running_command.dart';
import 'package:command_manager/utils.dart' as utils;
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ExecutionType { running, finished }

class CommandExecutionCard extends StatelessWidget {
  final RunningCommand rc;
  final ExecutionType type;
  const CommandExecutionCard({
    super.key,
    required this.rc,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CommandManagerViewModel>();
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => ProcessOutputDialog(
            title: rc.name,
            lines: rc.lines,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(rc.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PID: ${rc.pid}'),
              Text(
                  '${AppLocalizations.of(context)!.startTime}: ${rc.startTime}'),
              Text(
                rc.lines.take(5).map((line) => line.trimRight()).join('\n'),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: type == ExecutionType.running
              ? IconButton(
                  icon: const Icon(Icons.stop_circle, color: Colors.red),
                  tooltip: AppLocalizations.of(context)!.terminateProcess,
                  onPressed: () {
                    vm.killProcess(rc.pid);
                  })
              : IconButton(
                  icon: const Icon(Icons.play_arrow),
                  tooltip: AppLocalizations.of(context)!.run,
                  onPressed: () async {
                    AppSnackbar.show(context,
                        AppLocalizations.of(context)!.startCommand(rc.name));
                    await vm.runCommandByName(rc.name);
                    if (context.mounted) {
                      AppSnackbar.show(context,
                          AppLocalizations.of(context)!.endCommand(rc.name));
                    }
                  }),
        ),
      ),
    );
  }
}

class ProcessOutputDialog extends StatelessWidget {
  final String title;
  final List<String> lines;

  const ProcessOutputDialog({
    super.key,
    required this.title,
    required this.lines,
  });

  String get _cleanedText => lines.where((line) => line.isNotEmpty).join('\n');

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.6;
    final maxWidth = mediaQuery.size.width * 0.6;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
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
