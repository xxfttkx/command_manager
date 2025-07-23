import 'dart:io';

class RunningCommand {
  final int pid;
  final String name;
  final Process? process;
  final DateTime startTime;
  StringBuffer output = StringBuffer();

  RunningCommand({
    required this.pid,
    required this.name,
    required this.process,
    required this.startTime,
  });
}
