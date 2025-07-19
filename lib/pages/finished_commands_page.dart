import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/command_manager_viewmodel.dart';

class FinishedCommandsPage extends StatelessWidget {
  const FinishedCommandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CommandManagerViewModel>();
    final finishedCommands = vm.finishedCommands;

    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.finishedCommands)),
      body: finishedCommands.isEmpty
          ? Center(
              child: Text(AppLocalizations.of(context)!.noFinishedCommands))
          : ListView.builder(
              itemCount: finishedCommands.length,
              itemBuilder: (context, index) {
                final command =
                    finishedCommands[finishedCommands.length - 1 - index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(command.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PID: ${command.pid}'),
                        Text(
                            '${AppLocalizations.of(context)!.startTime}: ${command.startTime}'),
                        Text(
                          command.output
                              .toString()
                              .replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), ''),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        tooltip: AppLocalizations.of(context)!.run,
                        onPressed: () async {
                          AppSnackbar.show(
                              context,
                              AppLocalizations.of(context)!
                                  .startCommand(command.name));
                          await vm.runCommandByName(command.name);
                          if (context.mounted) {
                            AppSnackbar.show(
                                context,
                                AppLocalizations.of(context)!
                                    .endCommand(command.name));
                          }
                        }),
                  ),
                );
              },
            ),
    );
  }
}
