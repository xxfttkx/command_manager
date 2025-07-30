import 'dart:io';

class RunningCommand {
  final int pid;
  final String name;
  final Process? process;
  final DateTime startTime;
  List<String> lines = [];
  int count = 0;
  RunningCommand({
    required this.pid,
    required this.name,
    required this.process,
    required this.startTime,
  });
}
