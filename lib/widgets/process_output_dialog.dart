import 'package:command_manager/utils.dart' as utils;
import 'package:command_manager/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';

class ProcessOutputDialog extends StatelessWidget {
  final String title;
  final List<String> lines;

  const ProcessOutputDialog({
    super.key,
    required this.title,
    required this.lines,
  });

  String get _cleanedText => lines.where((line) => line.isNotEmpty).join('\n');

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.6;
    final maxWidth = mediaQuery.size.width * 0.6;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
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
          controller: controller,
          child: ListView.builder(
            controller: controller,
            physics: const ClampingScrollPhysics(),
            itemCount: lines.length,
            // addAutomaticKeepAlives: false,
            // addRepaintBoundaries: false, // 也可以设为 false 避免 GPU 分片
            // itemExtent: 30, // 如果每项高度固定，建议加这个，极大提升性能
            prototypeItem: const Text(
              'Sample line for prototype',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            itemBuilder: (context, index) {
              final line = lines[index];
              return Text(
                line,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
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
