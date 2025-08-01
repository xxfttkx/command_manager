import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:command_manager/widgets/command_execution_card.dart';
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
                return CommandExecutionCard(
                    rc: finishedCommands[finishedCommands.length - 1 - index],
                    type: ExecutionType.finished);
              },
            ),
    );
  }
}
