import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../models/command_action.dart';

enum CommandCardActionType { run, edit, delete, copyText, duplicate }

class CommandCard extends StatelessWidget {
  final CommandAction action;
  final void Function(CommandCardActionType) onAction;

  const CommandCard({
    super.key,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  action.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      tooltip: AppLocalizations.of(context)!.run,
                      onPressed: () => onAction(CommandCardActionType.run),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: AppLocalizations.of(context)!.copy,
                      onPressed: () => onAction(CommandCardActionType.copyText),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: AppLocalizations.of(context)!.edit,
                      onPressed: () => onAction(CommandCardActionType.edit),
                    ),
                    IconButton(
                      icon: const Icon(Icons.library_add),
                      tooltip: AppLocalizations.of(context)!.duplicate,
                      onPressed: () =>
                          onAction(CommandCardActionType.duplicate),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: AppLocalizations.of(context)!.delete,
                      onPressed: () => onAction(CommandCardActionType.delete),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              action.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ...action.commands.map(
              (cmd) => Text(
                '> $cmd',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
