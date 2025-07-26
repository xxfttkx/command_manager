import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/models/running_command.dart';
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          builder: (_) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rc.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy',
                  onPressed: () {
                    final textToCopy = rc.output
                        .toString()
                        .replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '');
                    Clipboard.setData(ClipboardData(text: textToCopy));
                    AppSnackbar.show(context, 'Copied to clipboard');
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Text(
                rc.output
                    .toString()
                    .replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), ''),
              ),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
              ),
            ],
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
                rc.output
                    .toString()
                    .replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), ''),
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
