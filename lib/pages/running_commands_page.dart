import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/command_manager_viewmodel.dart';

class RunningCommandsPage extends StatelessWidget {
  const RunningCommandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CommandManagerViewModel>();
    final running = vm.runningCommands;

    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.runningCommands)),
      body: running.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noRunningCommands))
          : ListView.builder(
              itemCount: running.length,
              itemBuilder: (context, index) {
                final rc = running[index];
                return Card(
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
                          maxLines: 5,
                          rc.output
                              .toString()
                              .replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), ''),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.stop_circle, color: Colors.red),
                      tooltip: AppLocalizations.of(context)!.terminateProcess,
                      onPressed: () {
                        vm.killProcess(rc.pid);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
