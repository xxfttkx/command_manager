import 'package:command_manager/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../models/command_action.dart';

class CommandCard extends StatelessWidget {
  final CommandAction action;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRun;

  const CommandCard({
    super.key,
    required this.action,
    required this.onEdit,
    required this.onDelete,
    required this.onRun,
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
                      onPressed: onRun,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: AppLocalizations.of(context)!.edit,
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: AppLocalizations.of(context)!.delete,
                      onPressed: onDelete,
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
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
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
