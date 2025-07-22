import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/widgets/running_command_card.dart';
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
                return CommandExecutionCard(
                    rc: running[index], type: ExecutionType.running);
              },
            ),
    );
  }
}
