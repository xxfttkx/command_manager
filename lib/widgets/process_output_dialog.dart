import 'package:command_manager/utils.dart' as utils;
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';

class ProcessOutputDialog extends StatefulWidget {
  final String title;
  final List<String> lines;

  const ProcessOutputDialog({
    super.key,
    required this.title,
    required this.lines,
  });

  @override
  State<ProcessOutputDialog> createState() => _ProcessOutputDialogState();
}

class _ProcessOutputDialogState extends State<ProcessOutputDialog> {
  static const int pageSize = 100;
  late ScrollController _controller;
  int _visibleCount = pageSize;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  void _loadNextPage() {
    if (_visibleCount < widget.lines.length) {
      setState(() {
        _visibleCount =
            (_visibleCount + pageSize).clamp(0, widget.lines.length);
      });
    }
  }

  String get _cleanedText =>
      widget.lines.where((line) => line.isNotEmpty).join('\n');

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.6;
    final maxWidth = mediaQuery.size.width * 0.6;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(widget.title, overflow: TextOverflow.ellipsis)),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy',
            onPressed: () {
              utils.copyToClipboard(_cleanedText);
              AppSnackbar.show(context, 'Copied to clipboard');
            },
          ),
        ],
      ),
      content: SizedBox(
        height: maxHeight,
        width: maxWidth,
        child: Scrollbar(
          controller: _controller,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 100) {
                _loadNextPage();
              }
              return false;
            },
            child: ListView.builder(
              controller: _controller,
              physics: const ClampingScrollPhysics(),
              itemCount: _visibleCount,
              itemBuilder: (context, index) {
                final line = widget.lines[index];
                return Text(line);
              },
            ),
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
