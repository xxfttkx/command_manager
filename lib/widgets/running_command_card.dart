import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/models/running_command.dart';
import 'package:command_manager/viewmodels/command_manager_viewmodel.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CommandType { runningCommand, finishedCommand }

class CommandExecutionCard extends StatelessWidget {
  final RunningCommand rc;
  final CommandType type;
  const CommandExecutionCard({
    Key? key,
    required this.rc,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CommandManagerViewModel>(); // 替换成你的 ViewModel 类型
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(rc.name),
            content: SingleChildScrollView(
              child: Text(
                rc.output
                    .toString()
                    .replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), ''),
              ),
            ),
            actions: [
              TextButton(
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
          trailing: type == CommandType.runningCommand
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
