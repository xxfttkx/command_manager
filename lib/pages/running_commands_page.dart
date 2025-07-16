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
      appBar: AppBar(title: const Text('正在运行的命令')),
      body: running.isEmpty
          ? const Center(child: Text('暂无正在运行的命令'))
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
                        Text('启动时间: ${rc.startTime}'),
                        Text(
                          rc.output.toString(),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.stop_circle, color: Colors.red),
                      tooltip: '终止进程',
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
